# Makefile: helper targets to generate categories before Jekyll build/serve

SCRIPTS_FOLDER   =scripts
KATEGORIES_FOLDER=kategorie
ROW_IMAGES_FOLDER=big_photos
TO_REMOVE_FOLDER =to-remove
GENERATED_FOLDER =generated

KEEP_SRC=./dont_include/Keep

RED    := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
BLUE   := $(shell printf '\033[0;34m')
PURPLE := $(shell printf '\033[0;35m')
CYAN   := $(shell printf '\033[0;36m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')

POST_FILES := $(shell find _posts -type f -name '*.md')

.PHONY: build serve gen-categories install

all: serve

$(ROW_IMAGES_FOLDER):
	mkdir -p $(ROW_IMAGES_FOLDER)

$(KATEGORIES_FOLDER):
	mkdir -p $(KATEGORIES_FOLDER)

$(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER):
	mkdir -p $(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)

# jekyll
INSTALL-DEPS = Install dependencies
install-deps:
	@printf "$(CYAN)Installing dependencies...$(RESET)\n"
	./install_dependencies.sh

INSTALL = Install dependencies and Ruby gems
install: install-deps $(ROW_IMAGES_FOLDER)
	@printf "$(CYAN)Installing Ruby gems...$(RESET)\n"
	bundle install

GEN-CATEGORIES = Generate category pages
gen-categories: $(KATEGORIES_FOLDER)
	@printf "$(CYAN)Generating category pages...$(RESET)\n"
	@python3 $(SCRIPTS_FOLDER)/generate_category_pages.py

BUILD = Build the site
build: gen-categories word-count
	@printf "$(CYAN)Building site...$(RESET)\n"
	bundle exec jekyll build

DOCTOR = Run Jekyll doctor to check for issues
doctor: build
	@printf "$(CYAN)Running Jekyll doctor...$(RESET)\n"
	bundle exec jekyll doctor

SERVE = Serve the site with live reload
serve: build 
	@printf "$(CYAN)Serving site (live reload)...$(RESET)\n"
	bundle exec jekyll serve --incremental

# image processing
rotate-images: $(ROW_IMAGES_FOLDER)
	@printf "$(CYAN)Rotating images...$(RESET)\n"
	@./rotate_right.sh

move-originals: $(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)
	@printf "$(CYAN)Moving original images to '$(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)'...$(RESET)\n"
	@find ./$(ROW_IMAGES_FOLDER) -maxdepth 1 -type f \
		\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) \
		-exec mv -t ./$(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)/ -- {} + 2>/dev/null || true
	@printf "$(YELLOW)Original images moved to '$(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)' folder. Review and delete if no longer needed.$(RESET)\n"

resize-images: 
	@printf "$(CYAN)Resizing images...$(RESET)\n"
	@./$(SCRIPTS_FOLDER)/convert_to_webp.sh -d ./$(ROW_IMAGES_FOLDER)/
	make move-originals
	@printf "$(CYAN)Done.$(RESET) WebP images in $(BLUE)$(ROW_IMAGES_FOLDER):$(RESET)\n"
	@ls ./$(ROW_IMAGES_FOLDER)/ | grep '.webp' 

# recipe conversion from Google Keep
keep-to-simplenote:
	@printf "$(CYAN)Convert Keep notes to Simplenote format...$(RESET)\n"
	# verify source folder exists and is not empty
	@if [ ! -d "$(KEEP_SRC)" ]; then \
	  echo "Directory '$(KEEP_SRC)' not found. Create or adjust path before running."; \
	  exit 1; \
	fi
	@if [ -z "$$((ls -A $(KEEP_SRC) 2>/dev/null) || true)" ]; then \
	  echo "Directory '$(KEEP_SRC)' is empty. Add files before running."; \
	  exit 1; \
	fi

	@python3 $(SCRIPTS_FOLDER)/keep_to_simplenote.py

keep-json-to-recipe: keep-to-simplenote
	@printf "$(CYAN)Convert Keep JSON recipes to markdown...$(RESET)\n"
	@python3 $(SCRIPTS_FOLDER)/keep_json_to_recipe_md.py

generated/word_count.txt: $(POST_FILES) $(SCRIPTS_FOLDER)/count_words.sh
	@printf "$(CYAN)Calculating word count...$(RESET)\n"
	@./$(SCRIPTS_FOLDER)/count_words.sh -p
	@./$(SCRIPTS_FOLDER)/count_words.sh -p > $@

WORD-COUNT = Calculate word count of posts
word-count: generated/word_count.txt

Clean = Clean generated files
clean:
	@printf "$(CYAN)Cleaning generated category pages...$(RESET)\n"
	rm -rf $(KATEGORIES_FOLDER)/*
	@printf "$(CYAN)Cleaning generated word count...$(RESET)\n"
	rm -rf $(GENERATED_FOLDER)/*

help:
	@printf "$(CYAN)Available targets:$(RESET)\n"
	@printf "  $(BOLD)install$(RESET)             - ${INSTALL}\n"
	@printf "  $(BOLD)gen-categories$(RESET)      - ${GEN-CATEGORIES}\n"
	@printf "  $(BOLD)build$(RESET)               - ${BUILD}\n"
	@printf "  $(BOLD)serve$(RESET)               - ${SERVE}\n"
	@printf "  $(BOLD)rotate-images$(RESET)       - Rotate images in '$(ROW_IMAGES_FOLDER)'\n"
	@printf "  $(BOLD)move-originals$(RESET)      - Move original images to '$(ROW_IMAGES_FOLDER)/$(TO_REMOVE_FOLDER)'\n"
	@printf "  $(BOLD)resize-images$(RESET)       - Resize images in '$(ROW_IMAGES_FOLDER)' to WebP format\n"
	@printf "  $(BOLD)keep-to-simplenote$(RESET)  - Convert Google Keep notes to Simplenote format\n"
	@printf "  $(BOLD)keep-json-to-recipe$(RESET) - Convert Keep JSON recipes to markdown\n"
	@printf "  $(BOLD)word-count$(RESET)          - ${WORD-COUNT}\n"
	@printf "  $(BOLD)clean$(RESET)               - ${Clean}\n"