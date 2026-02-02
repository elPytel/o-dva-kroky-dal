# Makefile: helper targets to generate categories before Jekyll build/serve

SCRIPTS_FOLDER=scripts
KEEP_SRC=./dont_include/Keep

.PHONY: build serve gen-categories

# jekyll
install-deps:
	@echo "Installing dependencies..."
	./install_dependencies.sh

install: install-deps
	@echo "Installing Ruby gems..."
	bundle install
y
gen-categories:
	@echo "Generating category pages..."
	@python3 $(SCRIPTS_FOLDER)/generate_category_pages.py

build: gen-categories
	@echo "Building site..."
	bundle exec jekyll build

serve: gen-categories
	@echo "Serving site (live reload)..."
	bundle exec jekyll serve

# image processing
rotate-images:
	@echo "Rotating images..."
	@./rotate_images.sh

resize-images:
	@echo "Resizing images..."
	@./resize_images.sh

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
	@rm -rf categories/