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
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')
else
RED :=
GREEN :=
YELLOW :=
BLUE :=
BOLD :=
RESET :=
endif

.PHONY: build serve gen-categories install

all: install build

$(ROW_IMAGES_FOLDER):
	mkdir -p $(ROW_IMAGES_FOLDER)

$(KATEGORIES_FOLDER):
	mkdir -p $(KATEGORIES_FOLDER)

# jekyll
install-deps:
	@echo "Installing dependencies..."
	./install_dependencies.sh

install: install-deps
	@echo "Installing Ruby gems..."
	bundle install

gen-categories: $(KATEGORIES_FOLDER)
	@echo "Generating category pages..."
	@python3 $(SCRIPTS_FOLDER)/generate_category_pages.py

build: gen-categories
	@echo "Building site..."
	bundle exec jekyll build

serve: gen-categories
	@echo "Serving site (live reload)..."
	bundle exec jekyll doctor
	bundle exec jekyll serve

# image processing
rotate-images: $(ROW_IMAGES_FOLDER)
	@echo "Rotating images..."
	@./rotate_images.sh

resize-images:
	@echo "Resizing images..."
	@./$(SCRIPTS_FOLDER)/convert_to_webp.sh

# recipe conversion from Google Keep
keep-to-simplenote:
	@echo "Convert Keep notes to Simplenote format..."
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
	@echo "Convert Keep JSON recipes to markdown..."
	@python3 $(SCRIPTS_FOLDER)/keep_json_to_recipe_md.py

clean:
	@echo "Cleaning generated category pages..."
	@rm -rf $(KATEGORIES_FOLDER)/*