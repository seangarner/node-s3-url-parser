SRC ?= lib
LIB ?= lib
TESTS = test

NAME ?= $(shell node -e 'console.log(require("./package.json").name)')
VERSION ?= $(shell node -e 'console.log(require("./package.json").version)')

NODE ?= $(shell which node)
NPM ?= $(shell which npm)
JSHINT ?= node_modules/jshint/bin/jshint
MOCHA ?= node_modules/mocha/bin/mocha
REPORTER ?= spec

test:
	@echo -----------------
	@echo - RUNNING TESTS -
	@echo -----------------
	$(NODE) $(MOCHA) --reporter $(REPORTER) $(TESTS)

test-dev:
	@echo ---------------------------------------------
	@echo - TESTS AUTOMATICALLY RERUN ON FILE CHANGES -
	@echo ---------------------------------------------
	$(NODE) $(MOCHA) $(TESTS) $(INTEGRATION_TESTS) --reporter $(REPORTER) --watch $(LIB)

dev:
	@echo -----------------------
	@echo - INSTALLING DEV DEPS -
	@echo -----------------------
	$(NPM) install

lint:
	@echo ------------------
	@echo - LINTING SOURCE -
	@echo ------------------
	$(NODE) $(JSHINT) $(SRC)

	@echo -----------------
	@echo - LINTING TESTS -
	@echo -----------------
	$(NODE) $(JSHINT) $(TESTS)

safe:
	nsp check

release: lint test safe
	@echo ------------------------------------------
	@echo - ready to bump versions and npm release -
	@echo ------------------------------------------
	@echo
	@echo   - bump package.json
	@echo   - bump CHANGELOG.md
	@echo   - git commit, push & tag
	@echo   - npm publish

.PHONY: dev lint test test-dev release safe
