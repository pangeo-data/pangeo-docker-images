-include .env

# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-image base-notebook pangeo-notebook ml-notebook pytorch-notebook
TESTDIR=/srv/test

.PHONY: base-image
base-image :
	cd base-image ; \
	docker build -t cnes/base-image:master --progress=plain --platform linux/amd64 .

.PHONY: base-notebook
base-notebook : base-image
	cd base-notebook ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	conda-lock render -k explicit -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t cnes/base-notebook:master . --no-cache --progress=plain --platform linux/amd64; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/base-notebook:master ./run_tests.sh base-notebook

.PHONY: pangeo-notebook
pangeo-notebook : base-image
	cd pangeo-notebook ; \
	cp -r ../base-notebook/resources . ; \
	conda-lock lock --mamba -f environment.yml -f ../base-notebook/environment.yml -f ../base-notebook/environment.yml -p linux-64; \
	conda-lock render -k explicit -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	../merge-apt.sh ../base-notebook/apt.txt apt.txt; \
	docker build -t cnes/pangeo-notebook:master . --progress=plain --platform linux/amd64; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/pangeo-notebook:master ./run_tests.sh pangeo-notebook

.PHONY: pytorch-notebook
pytorch-notebook : base-image
	cd pytorch-notebook ; \
	conda-lock lock --mamba -f environment.yml -f ../pangeo-notebook/environment.yml -f ../base-notebook/environment.yml -p linux-64; \
	conda-lock render -k explicit -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t cnes/pytorch-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) cnes/pytorch-notebook:master ./run_tests.sh pytorch-notebook
