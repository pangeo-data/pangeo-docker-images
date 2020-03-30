# Makefile for convenience
.PHONY: base-image base-notebook pangeo-notebook ml-notebook

base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

base-notebook : base-image
	cd base-notebook ; \
	../update_lockfile.sh ../base-image/condarc.yml; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/base-notebook:master ./run_tests.sh base-notebook

pangeo-notebook : base-image
	cd pangeo-notebook ; \
	../update_lockfile.sh ../base-image/condarc.yml; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

ml-notebook : base-image
	cd ml-notebook ; \
	../update_lockfile.sh condarc.yml; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -v $(PWD):/home/jovyan pangeo/ml-notebook:master ./run_tests.sh ml-notebook
