.PHONY: all lint test init-view-submodule vendor-view install dev dev-no-view clean distclean

PYTHON ?= python
PREFIX ?= $(CONDA_PREFIX)

all: ;

lint:
	q2lint
	flake8

test: all
	QIIMETEST= pytest

vendor-view: all
	git submodule init && \
	git submodule update && \
	cd q2view && \
	npm install --no-save && \
	npm run vendor --VENDOR_DIR=../q2cli/assets/view

# install pytest-xdist plugin for the `-n auto` argument.
mystery-stew: all
	MYSTERY_STEW= pytest -k mystery_stew -n auto

install: vendor-view all
	$(PYTHON) -m pip install -v . && \
	mkdir -p $(PREFIX)/etc/conda/activate.d && \
	cp hooks/50_activate_q2cli_tab_completion.sh $(PREFIX)/etc/conda/activate.d/

dev: dev-no-view vendor-view all

dev-no-view: all
	pip install -e . && \
	mkdir -p $(PREFIX)/etc/conda/activate.d && \
	cp hooks/50_activate_q2cli_tab_completion.sh $(PREFIX)/etc/conda/activate.d/

clean: distclean
	rm -rf ./q2cli/assets

distclean: ;
