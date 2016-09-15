# Installation:
#   brew install python # then load a new shell
#   pip install virtualenv
#   pip install virtualenvwrapper
#
# VirtualEnvWrapper documentation: http://virtualenvwrapper.readthedocs.org/en/latest/
#

# virtualenv
# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# virtualenvwrapper
# where should we store our virtual environments?
export WORKON_HOME=~/.virtualenv
# load virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh
