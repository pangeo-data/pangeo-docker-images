.PHONY: base-image base-notebook pangeo-notebook ml-notebook

base-image :
	cd base-image ; \
	docker build -t pangeodev/base-image:master .

base-notebook : base-image
	cd base-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/base-notebook:master .

pangeo-notebook : base-image
	cd pangeo-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/pangeo-notebook:master .

ml-notebook : base-image
	cd ml-notebook ; \
	docker build -f ../Dockerfile -t pangeodev/ml-notebook:master .
