# -*- coding: utf-8 -*-
from setuptools import setup, find_packages

import os
from codecs import open

HERE = os.path.abspath(os.path.dirname(__file__))

# Get the long description from the README file
with open(os.path.join(HERE, "./README.md"), encoding="utf-8") as f:
    LONG_DESCRIPTION = f.read()

with open(os.path.join(HERE, "helics_cli", "_version.py"), encoding="utf-8") as f:
    VERSION = f.read()

VERSION = VERSION.splitlines()[1].split()[2].strip('"').strip("'")

setup(
    name="helics_cli",
    version=VERSION,
    description="Python direct-mode interface to OpenDSS",
    long_description=LONG_DESCRIPTION,
    url="https://github.com/GMLC-TDC/helics-cli",
    download_url="https://github.com/GMLC-TDC/helics-cli",
    # Author details
    author="Dheepak Krishnamurthy",
    license="BSD-compatible",
    packages=find_packages(),
    install_requires=["future", "six", "click", "jinja2"],
    keywords=["helics", "cosimulation"],
    include_package_data=True,
    package_data={
        "helics_cli": [
            "templates/helics-federate-config.json",
            "templates/helics-runner-config.json",
            "templates/python-federate-config.json",
            "plugins/config/opendssdirect/opendssdirect-federate-config.json",
            "plugins/config/gridlabd/gridlabd-federate-config.json",
        ]
    },
    entry_points={
        "console_scripts": ["helics = helics_cli.cli:cli"],
        "helics_cli.plugins.config": [
            "gridlabd=helics_cli.plugins.config.gridlabd:GridLABDConfig",
            "opendssdirect=helics_cli.plugins.config.opendssdirect:OpenDSSDirectConfig",
        ],
    },
    extras_require={
        "dev": [
            "pytest",
            "pytest-cov",
            "sphinx-rtd-theme",
            "nbsphinx",
            "sphinx",
            "ghp-import",
        ]
    },
    # If there are data files included in your packages that need to be
    # installed, specify them here.  If using Python 2.6 or less, then these
    # have to be included in MANIFEST.in as well.
    zip_safe=True,
    # See https://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        # How mature is this project? Common values are
        #   3 - Alpha
        #   4 - Beta
        #   5 - Production/Stable
        "Development Status :: 4 - Beta",
        # Indicate who your project is intended for
        "Intended Audience :: Science/Research",
        "Intended Audience :: Education",
        "Intended Audience :: Developers",
        "Topic :: Software Development :: Build Tools",
        # Pick your license as you wish (should match "license" above)
        "License :: Other/Proprietary License",
        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        "Programming Language :: Python :: 2.7",
        "Programming Language :: Python :: 3.5",
        "Programming Language :: Python :: 3.6",
    ],
)
