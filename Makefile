# Makefile for convenience, (doesn't look for command outputs)
.PHONY: all
all: base-image base-notebook pangeo-notebook ml-notebook
TESTDIR=/srv/test

.PHONY: base-image
base-image :
	cd base-image ; \
	docker build -t pangeo/base-image:master .

.PHONY: base-notebook
base-notebook : base-image
	cd base-notebook ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/base-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/base-notebook:master ./run_tests.sh base-notebook

.PHONY: pangeo-notebook
pangeo-notebook : base-image
	cd pangeo-notebook ; \
	conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/pangeo-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/pangeo-notebook:master ./run_tests.sh pangeo-notebook

.PHONY: ml-notebook
ml-notebook : base-image
	cd ml-notebook ; \
	CONDARC=condarc.yml conda-lock lock --mamba -f environment.yml -p linux-64; \
	../list_packages.sh | sort > packages.txt; \
	docker build -t pangeo/ml-notebook:master . ; \
	docker run -w $(TESTDIR) -v $(PWD):$(TESTDIR) pangeo/ml-notebook:master ./run_tests.sh ml-notebook
