# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-image base-notebook pangeo-notebook ml-notebook pytorch-notebook
TESTDIR=/srv/test

.PHONY: base-image
base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

.PHONY: base-notebook
base-notebook : base-image
	cd base-notebook ; \
	conda-lock lock --mamba -k explicit -f environment.yml -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/base-notebook:master ./run_tests.sh base-notebook

.PHONY: pangeo-notebook
pangeo-notebook : base-image
	cd pangeo-notebook ; \
	conda-lock lock --mamba -k explicit -f environment.yml -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

.PHONY: ml-notebook
ml-notebook : base-image
	cd ml-notebook ; \
	conda-lock lock --mamba -k explicit -f environment.yml -f ../pangeo-notebook/environment.yml -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/ml-notebook:master ./run_tests.sh ml-notebook

.PHONY: pytorch-notebook
pytorch-notebook : base-image
	cd pytorch-notebook ; \
	conda-lock lock --mamba -f environment.yml -f ../pangeo-notebook/environment.yml -p linux-64; \
	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
	docker build -t pangeo/pytorch-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pytorch-notebook:master ./run_tests.sh pytorch-notebook



.PHONY: jax-notebook
jax-notebook : base-image
	cd jax-notebook ; \
 	conda-lock lock --mamba -f environment.yml -f ../pangeo-notebook/environment.yml -p linux-64; \
 	../generate-packages-list.py conda-linux-64.lock > packages.txt; \
 	docker build -t pangeo/jax-notebook:master . ; \
 	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pytorch-notebook:master ./run_tests.sh pytorch-notebook

