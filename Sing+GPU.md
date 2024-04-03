# Jupyter Notebook + Singularity + GPU support on the HPC System 


Singularity brings containers into traditional HPC use cases and centers. (FYI: It has been moved into the Linux Foundation and renamed Apptainer).

We first need download and use [one of the images created by Pangeo](https://github.com/pangeo-data/pangeo-docker-images). They are all hosted on [Dockerhub](https://hub.docker.com/u/pangeo)

## Downloading the image

After ssh-ing into your HPC system, load Singularity:

```
module load singularity 
```

Pull the desired image (for example the ml-notebook which uses TensorFlow and GPUs) under our name of choice (in our case `tensorflow.sif`):

```
singularity pull tensorflow.sif docker://pangeo/ml-notebook
```

**Note I:** Depending on the size of the image, this could take some time and some warnings may appear. It may be a good idea to do some other work in the meantime.

**Note II:** If we were to choose a different image, just change what follows after `docker://` for the name of the image appearing on  [Dockerhub](https://hub.docker.com/u/pangeo).

After being patient, the file `tensorflow.sif` should be available in the home folder.

## Running the Batch Job

To request resources and have a Jupyter Notebook running on a computing node it is necessary to have a batch script under, for example, the name `batch_tflw_v100s.sh`.

To create it run `vi batch_tflw_v100s.sh` and paste the below command text.

<span style="color:red">**Important:**</span> Make sure all paths are the relevant to your given case.

```
#!/bin/sh
#
#SBATCH --account=abernathey     # The account name for the job.
#SBATCH --job-name=jupyter       # The job name.
#SBATCH --gres=gpu:1             # Request 1 gpu (Up to 2 gpus per GPU node)
#SBATCH --partition=ocp_gpu
#SBATCH --constraint=v100s
#SBATCH -c 32                    # The number of cpu cores to use.
#SBATCH --time=0-04:00           # The time the job will take to run in D-HH:MM
#SBATCH --output=/home/$USER/jupyter.log # Important to retrieve the port where the notebook is running, if not included a slurm file with the job-id will be outputted. 

module load singularity

cat /etc/hosts
singularity exec --nv --cleanenv --bind /home/$USER:/run/user tensorflow.sif jupyter notebook --notebook-dir=/home/$USER --no-browser --ip=0.0.0.0
```

To exit the Vi editor, make sure to be in command mode by pressing `ESC`and then `:wq` to write and quit.

In this case, V100s GPUs are allocated if available. The [Ginsburg official guide](https://confluence.columbia.edu/confluence/display/rcs/Ginsburg+-+Job+Examples#GinsburgJobExamples-GPU(CUDAC/C++)) describes how to manage resource requests.

To enter the queue, run:

```
sbatch batch_tflw_v100s.sh
```

Once the job is running, the `jupyter.log` file should show which node you are using and in which port it is referenced. To obtain this, run:

```
cat jupyter.log
```

A line like `[I 15:14:51.868 NotebookApp] http://g051:8888/` should appear. In this case, `g051` is the node name and `8888` is the port.

## Running the Jupyter Notebook

### Forwarding the Port

In your local computer's terminal, forward the port by running (change `USER@domain.edu` for your account),

```
ssh -N -L lochalhost:8080:g051:8888 USER@domain.edu
```

This forwards your port `8888` from the HPC system to your port `8080` on your machine.

Then, in a web browser you should be able to access the Jupyter Notebook by writing:  

![](https://i.imgur.com/ezXUVEv.png)

#### Sanity Checks

- The requested GPU should support your TensorFlow notebook:

![](https://i.imgur.com/g9tzOiQ.png)

- The python kernel should be the `Python 3 (ipykernel)`

![](https://i.imgur.com/CwTHtZk.png)

- Which points to the following path:

![](https://i.imgur.com/Lz3N88g.png)

### Connecting to remote host (VSCode)

If you are using VSCode, it is possible to connect to the allocated node directly without forwarding the port.

Make sure Remote-SSH, Python and Jupyter extensions are installed on VSCode.

1. Connect to your HPC system with Remote-SSH in VSCode.

2. Open a Jupyter Notebook.

3. Select the kernel on the top right under the gear wheel and then `Connect to a Jupyter Server`.

4. Introduce the URL (`http://g051:8888/`) and select the `Python 3 (ipykernel)`

5. Check for GPUs

![](https://i.imgur.com/XJp5IZd.png)
