# Makefile for convenience
.PHONY: base-image base-notebook pangeo-notebook ml-notebook

base-image :
	cd base-image ; \
	docker build -t pangeodev/base-image:master .

base-notebook : base-image
	./update_lockfile.sh base-notebook ; \
	cd base-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/base-notebook:master .

pangeo-notebook : base-image
	./update_lockfile.sh pangeo-notebook ; \
	cd pangeo-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/pangeo-notebook:master .

ml-notebook : base-image
	CONDARC=ml-notebook/.condarc ./update_lockfile.sh ml-notebook ; \
	cd ml-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/ml-notebook:master .
