# Copyright 2024 CS GROUP - https://www.csgroup.eu
# All rights reserved
# This file is provided under MIT license. See LICENSE file.

import setuptools

setuptools.setup(
    name="jupyter-proxy",
    version="0.0.1",
    url="https://github.com/jupyterhub/jupyter-server-proxy/tree/master/contrib/theia",
    author="Project Jupyter Contributors",
    description="projectjupyter@gmail.com",
    packages=setuptools.find_packages(),
    keywords=["Jupyter"],
    classifiers=["Framework :: Jupyter"],
    install_requires=["jupyter-server-proxy"],
    entry_points={
        "jupyter_serverproxy_servers": [
            #'rstudio = jupyter_proxy:setup_rstudio',
            "codeserver = jupyter_proxy:setup_codeserver",
            "desktop = jupyter_proxy:setup_novnc",
        ]
    },
    package_data={
        "jupyter_proxy": ["icons/*"],
    },
)
