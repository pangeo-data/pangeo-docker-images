# Makefile for convenience
.PHONY: base-image base-notebook pangeo-notebook ml-notebook

base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

base-notebook : base-image
	CONDARC=base-image/condarc ./update_lockfile.sh base-notebook ; \
	cd base-notebook ; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/base-notebook:master ./run_tests.sh base-notebook

pangeo-notebook : base-image
	CONDARC=base-image/condarc ./update_lockfile.sh pangeo-notebook ; \
	cd pangeo-notebook ; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

ml-notebook : base-image
	CONDARC=ml-notebook/condarc ./update_lockfile.sh ml-notebook ; \
	cd ml-notebook ; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/ml-notebook:master ./run_tests.sh ml-notebook
