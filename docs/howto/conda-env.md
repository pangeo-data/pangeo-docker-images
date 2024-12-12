# How to install just the conda environment

If you're used to managing conda environments on your personal computer, or running a hosted JupyterLab service like [Google Colab](https://colab.research.google.com) or [AWS SageMaker Studio Lab](https://studiolab.sagemaker.aws), you can exactly match a tagged pangeo-notebook conda environment. For example, below we install the `pangeo-notebook` environment tagged on `2021.12.02`:

```
conda create -n pangeo-notebook --file https://raw.githubusercontent.com/cnes/datalabs-docker-images/2021.12.02/pangeo-notebook/conda-linux-64.lock
```
Note that this will only work on linux environments, since `conda-linux-64.lock` is specific to linux.
