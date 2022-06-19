# Instructions for compiling the documentation

## Install on basic Ubuntu 20.04
```
sudo apt-get install python-pip
sudo pip install sphinx
sudo pip install sphinx_rtd_theme
```

## Re-Generate API Documentation Setup
`sphinx-apidoc -f --ext-autodoc -o source/api/ctrl/ ../software/foboslib/ctrl/`

This needs work

## Compile PDF Version
`make latexpdf`

## Compile HTML Version
`make html`

