# How to create a new VRE Project from `datalabs-docker-images`

You have two options for creating a new VRE project based on `datalabs-docker-images`: you can either **FORK** this project or use a **FROM** instruction in your `Dockerfile`

## How to choose

A **FORK** is ideal for projects aiming to customize the VRE with specific `apt` or `conda` packages. This setup allows teams to manage updates independently and merge upstream changes on their own schedule.

The `Dockerfile` **FROM** approach is ideal for projects wanting to receive VRE updates continuously. By simply updating the VRE Docker image tag, projects can immediately integrate the latest changes and enhancements.

## Option 1 : Fork the Project

### Benefits of Forking

Forking allows you to take full advantage of the `ONBUILD` instructions defined in the `base-image`, enabling seamless customization.

### Which Image to modify

To select the most suitable image to modify for your needs, you need to review :  

* The list of Python packages in packages.txt
* The system packages in apt.txt
* Any scripts or additional resources in the resources directory. 

This will help you identify the image with dependencies closest to your requirements.

To facilitate upstream merging of the fork, rename any directories you don’t plan to use by adding a dot `(.)` before the folder name.
*However, do not rename the folder if you intend to build the base image locally and not pull from [Dockerhub](https://hub.docker.com/r/cnes/base-image).*

### Steps to Fork the Project

 1. **Fork the Project** 
Click on the "Fork" button on GitHub and follow the prompts to create your forked project.

 2. **Make Specific Modifications**
Depending on your needs, you can modify several components:
    * **To add Python packages**: Update the `environment.yml` file.
    * **To add apt packages**: Edit the `apt.txt` file.
    * **To install additional applications**: Create an `install.sh` script and place it under `resources/<application-name>/`.
    * **To add startup scripts for the VRE**: Create a shell script named `start-notebook-<name>.sh`, and move it to `/usr/local/bin/` within your `install.sh` script:
```bash
#Example
cp resources/folder/start-notebook-example.sh /usr/local/bin/
chmod +x /usr/local/bin/start-notebook-example.sh
```

 3. **Build the Project** 
 
Use the `make` command to build the image

```bash
#Example with base-notebook
make base-notebook
```

Then to run this image, run this command :

```bash
docker run -it --rm -p 8888:8888 cnes/base-notebook:master jupyter lab --ip 0.0.0.0 --allow-root --no-browser
```

### Syncing Your Fork with Upstream
To keep your fork updated with the original project:
 1. Add the upstream remote: 
```bash
git remote add upstream git@github.com:CNES/datalabs-docker-images.git
```
 2. Fetch the latest branches from the upstream repository:
```bash
git fetch upstream
```
 3. Switch to your main branch:
```bash
git checkout master
```
 4. Merge changes from upstream into your main branch:
```bash
git merge upstream/master
```
 5. Resolve any conflicts (if necessary), then complete the merge:
```bash
git merge --continue
```

## Option 2: Create a Dockerfile with `FROM`

If you prefer not to fork, you can create a custom Dockerfile by extending an existing image using the `FROM` instruction.
#### Example Dockerfile
```docker
FROM cnes/base-notebook:<image-tag>
```

You can then add any specific packages, configurations, or scripts by modifying the Dockerfile as needed.
#### Build

Build your Dockerfile with the following command:

```bash
docker build -t <name-of-the-image>:<tag> .
```