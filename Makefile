# Makefile: helper targets to generate categories before Jekyll build/serve

.PHONY: build serve gen-categories

gen-categories:
	@echo "Generating category pages..."
	@python3 scripts/generate_category_pages.py

build: gen-categories
	@echo "Building site..."
	bundle exec jekyll build

serve: gen-categories
	@echo "Serving site (live reload)..."
	bundle exec jekyll serve
