project = 'Datalabs Docker Stacks'
copyright = '2024, CNES Datalabs'
author = 'CNES Datalabs'


extensions = [
    "myst_parser",
]

myst_enable_extensions = [
    "deflist",
    "colon_fence",
    "linkify",
]

source_suffix = [".rst", ".md"]

templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = 'sphinx_book_theme'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']
