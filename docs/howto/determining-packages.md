# Determining Packages in Pangeo Docker Images

For deployments of Pangeo Docker Images using JupyterHub or Binder it can be sometimes unclear to the user exactly which image and tag is being used. Here are the images available as Pangeo Docker Images:

| Image           | Description                                   | 
|-----------------|-----------------------------------------------|
| [base-notebook](base-notebook/packages.txt) | minimally functional image for pangeo hubs | 
| [pangeo-notebook](pangeo-notebook/packages.txt) | base-notebook + core earth science analysis packages |
| [pytorch-notebook](pytorch-notebook/packages.txt) | pangeo-notebook + GPU-enabled pytorch |
| [ml-notebook](ml-notebook/packages.txt) | pangeo-notebook + GPU-enabled tensorflow2 | 
| [forge](ml-notebook/packages.txt) | pangeo-notebook + [Apache Beam](https://beam.apache.org/) support| 

Each image is also assigned a tag of the form `YYYY.MM.DD` indicating when it was last updated.

*Click on the image name in the table above for a current list of installed packages and versions for the most recent tag of each image*

## How to find my current image tag

The environment variable `JUPYTER_IMAGE_SPEC` will tell you what Pangeo Docker Image is currently in use.

### Using the command line with Bash

```bash
echo JUPYTER_IMAGE_SPEC: $JUPYTER_IMAGE_SPEC

tmp_array=($(echo $JUPYTER_IMAGE_SPEC | tr "/:" "\n"))
image_name=${tmp_array[1]}
image_tag=${tmp_array[2]}

echo image_name: $image_name
echo image_tag: $image_tag
```

### Using a Jupyter notebook with Python

```python
import os
image_spec = os.environ['JUPYTER_IMAGE_SPEC']
print('JUPYTER_IMAGE_SPEC:', image_spec)

_, image_name, image_tag = image_spec.replace('/',':').split(':')

print('image_name:', image_name)
print('image_tag:', image_tag)
```

## How to find the list of available image tags:

Using GitHub the web site, the list of select a particular tag from the branches/tag drop down menu.

## How to finding list of packages in any given tag

Each image has an `packages.txt` file that lists exactly which packages and versions installed in the image.

### Using GitHub website

Using GitHub the web [site](https://github.com/pangeo-data/pangeo-docker-images), select a particular tag from the branches/tag drop down menu.  Navigate to the image and select the `packages.txt` file.

### Using the command line with Bash

```bash
tmp_array=($(echo $JUPYTER_IMAGE_SPEC | tr "/:" "\n"))
image_name=${tmp_array[1]}
image_tag=${tmp_array[2]}

packages_url=https://raw.githubusercontent.com/pangeo-data/pangeo-docker-images/$image_tag/$image_name/packages.txt

curl -s $packages_url
```

### Using a Jupyter notebook with Python

```python
import os
image_spec = os.environ['JUPYTER_IMAGE_SPEC']
_, image_name, image_tag = image_spec.replace('/',':').split(':')

def get_package_list(image_name, image_tag):
    """Return a list of packages with versions in an image"""
    packages_url = f"https://raw.githubusercontent.com/pangeo-data/pangeo-docker-images/{image_tag}/{image_name}/packages.txt"
    
    import requests
    packages_str = requests.get(packages_url).content.decode('utf8')
    
    packages = []
    for package in packages_str.splitlines():
        if package[0] == '#': continue # skip the header
        package_name, package_version = package.split('==')
        packages.append((package_name, package_version))

    return packages

packages = get_package_list(image_name, image_tag)
print(f"{len(packages)} packages found in {image_spec}\n")
for package in packages:
    print(f"{package[0]}=={package[1]}")
```

## How to find difference in packages lists between any two tags

Suppose you want to find out what the differences are between 

`pangeo/pangeo-notebook:2023.06.07`

and

`pangeo/pangeo-notebook:2023.06.20`

to determine which packages were changed, added, or removed?

### Using the GitHub UI

You can compare tags within the GitHub UI by:

1. Finding the release for the tag, from https://github.com/pangeo-data/pangeo-docker-images/tags
2. Select the tag, so you get something like https://github.com/pangeo-data/pangeo-docker-images/tags
3. Use the 'compare' dropdown on the left to select another tag to compare it against
4. Look at the `packages.txt` of the appropriate image.

The link https://docs.github.com/en/pull-requests/committing-changes-to-your-project/viewing-and-comparing-commits/comparing-commits#comparing-tags has additional info.

### Using the command line with Bash

```bash
image_name=pangeo-notebook
image_tag_A=2023.06.07
image_tag_B=2023.06.20

url_A=https://raw.githubusercontent.com/pangeo-data/pangeo-docker-images/$image_tag_A/$image_name/packages.txt
url_B=https://raw.githubusercontent.com/pangeo-data/pangeo-docker-images/$image_tag_B/$image_name/packages.txt

diff -y --suppress-common-lines  --color <(curl -s $url_A) <(curl -s $url_B)

```

### Using a Jupyter notebook with Python

Using the `get_package_list` function defined above get a list of packages from both tags

```python
image_name = 'pangeo-notebook'
image_tag_A = '2023.06.07'
image_tag_B = '2023.06.20'

packages_A = get_package_list(image_name, image_tag_A)
packages_B = get_package_list(image_name, image_tag_B)
```

Determine which packages have been added or removed.

```python
import difflib
d = difflib.Differ()

added_packages = dict()
removed_packages = dict()
for package in d.compare(packages_A, packages_B):
    p = package[3:-1].split(', ')
    name = p[0][1:-1]
    version = p[1][1:-1]
    if package[0] == '+':
        added_packages[name] = version
    elif package[0] == '-':
        removed_packages[name] = version
```

Summarizing

```python
print(f'Differences in `packages.txt` for {image_name} between {image_tag_A} and {image_tag_B}')

print(f'Packages added:')
for name in sorted(set(added_packages) - set(removed_packages)):
    print(f"  {name} {added_packages[name]}")

print(f'Packages removed:')
for name in sorted(set(removed_packages) - set(added_packages)):
    print(f"  {name} {removed_packages[name]}")

print(f'Packages changed:')
for name in sorted((set(added_packages).intersection(set(removed_packages)))):
    print(f"  {name} {removed_packages[name]} -> {added_packages[name]}")
```
