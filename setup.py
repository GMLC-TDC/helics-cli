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
    description="HELICS command line interface",
    long_description=LONG_DESCRIPTION,
    url="https://github.com/GMLC-TDC/helics-cli",
    download_url="https://github.com/GMLC-TDC/helics-cli",
    author="Dheepak Krishnamurthy",
    license="BSD-compatible",
    packages=["web", "database"] + find_packages(),
    install_requires=["future", "six", "click>=8", "jinja2", "helics>=2.7.0", "flask", "matplotlib", "numpy"],
    keywords=["helics", "cosimulation"],
    include_package_data=True,
    entry_points={"console_scripts": ["helics = helics_cli.cli:cli"]},
    extras_require={
        "tests": ["pytest", "pytest-ordering", "pytest-cov"],
        "docs": ["mkdocs", "inari[mkdocs]", "mkdocs-material", "black", "pygments", "pymdown-extensions"],
    },
    # If there are data files included in your packages that need to be
    # installed, specify them here.  If using Python 2.6 or less, then these
    # have to be included in MANIFEST.in as well.
    zip_safe=False,
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
