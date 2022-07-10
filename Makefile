all: public/index.html

public/index.html: .github/workflows/index.yml .vscode/settings.json tools/branch-from-ref.py tools/nfkc.py 2022Q3.adoc README.bib Makefile
	black **/*.py && \
	pylama **/*.py && \
	python3 ./tools/nfkc.py --fix && \
	mkdir -p public && \
	cd public && \
	touch Gemfile && \
	printf "source 'https://rubygems.org'\n\ngem 'asciidoctor-revealjs'\n" > Gemfile && \
	bundle config --local path .bundle/gems && \
	bundle && \
	(if [ ! -d "reveal.js" ] ; then git clone -b 3.9.2 --depth 1 --single-branch https://github.com/hakimel/reveal.js.git ; fi ) && \
	rm -rf reveal.js/.git && \
	rm -rf reveal.js/.gitignore && \
	bundle exec asciidoctor-revealjs ../2022Q3.adoc && \
	mv ../2022Q3.html ./2022Q3.presentation.html && \
	asciidoctor -r asciidoctor-diagram -r asciidoctor-bibtex -o index.html ../2022Q3.adoc && \
	rm -rf .asciidoctor && \
	rm -rf .bundle
