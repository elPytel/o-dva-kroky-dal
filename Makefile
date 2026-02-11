# Makefile: helper targets to generate categories before Jekyll build/serve

SCRIPTS_FOLDER=scripts
KATEGORIES_FOLDER=kategorie
ROW_IMAGES_FOLDER=big_photos
KEEP_SRC=./dont_include/Keep

# Enable colored output (1 = on, 0 = off)
ENABLE_COLOR ?= 1

ifeq ($(ENABLE_COLOR),1)
RED    := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
BLUE   := $(shell printf '\033[0;34m')
PURPLE := $(shell printf '\033[0;35m')
CYAN   := $(shell printf '\033[0;36m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')
else
RED    :=
GREEN  :=
YELLOW :=
BLUE   :=
PURPLE :=
CYAN   :=
BOLD   :=
RESET  :=
endif

.PHONY: build serve gen-categories install

all: install build

$(ROW_IMAGES_FOLDER):
	mkdir -p $(ROW_IMAGES_FOLDER)

$(KATEGORIES_FOLDER):
	mkdir -p $(KATEGORIES_FOLDER)

# jekyll
install-deps:
	@printf "$(CYAN)Installing dependencies...$(RESET)\n"
	./install_dependencies.sh

install: install-deps
	@printf "$(CYAN)Installing Ruby gems...$(RESET)\n"
	bundle install

gen-categories: $(KATEGORIES_FOLDER)
	@printf "$(CYAN)Generating category pages...$(RESET)\n"
	@python3 $(SCRIPTS_FOLDER)/generate_category_pages.py

build: gen-categories word-count
	@printf "$(CYAN)Building site...$(RESET)\n"
	bundle exec jekyll build

doctor: build
	@printf "$(CYAN)Running Jekyll doctor...$(RESET)\n"
	bundle exec jekyll doctor

serve: gen-categories
	@printf "$(CYAN)Serving site (live reload)...$(RESET)\n"
	bundle exec jekyll serve

# image processing
rotate-images: $(ROW_IMAGES_FOLDER)
	@printf "$(CYAN)Rotating images...$(RESET)\n"
	@./rotate_right.sh

resize-images:
	@printf "$(CYAN)Resizing images...$(RESET)\n"
	@./$(SCRIPTS_FOLDER)/convert_to_webp.sh -d ./$(ROW_IMAGES_FOLDER)/

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

# scripts
word-count:
	@printf "$(CYAN)Calculating word count...$(RESET)\n"
	@./$(SCRIPTS_FOLDER)/count_words.sh -p

clean:
	@printf "$(CYAN)Cleaning generated category pages...$(RESET)\n"
	@rm -rf $(KATEGORIES_FOLDER)/*