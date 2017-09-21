from setuptools import setup, find_packages

import os
from codecs import open

here = os.path.abspath(os.path.dirname(__file__))

# Get the long description from the README file
with open(os.path.join(here, './README.md'), encoding='utf-8') as f:
    long_description = f.read()

with open(os.path.join(here, 'helics_runner', '_version.py'), encoding='utf-8') as f:
    version = f.read()

version = version.split()[2].strip('"').strip("'")


setup(
    name='helics_runner',

    version=version,

    description='Python direct-mode interface to OpenDSS',
    long_description=long_description,

    url='https://github.com/GMLC-TDC/helics-runner',
    download_url='https://github.com/GMLC-TDC/helics-runner',

    # Author details
    author='Dheepak Krishnamurthy',
    author_email='dheepak.krishnamurthy@nrel.gov',

    license='BSD-compatible',

    packages=find_packages(),
    install_requires=[
        "future",
        "six",
        "click",
    ],

    keywords=['helics', 'cosimulation'],

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
        'Development Status :: 4 - Beta',

        # Indicate who your project is intended for
        'Intended Audience :: Science/Research',
        'Intended Audience :: Education',
        'Intended Audience :: Developers',
        'Topic :: Software Development :: Build Tools',

        # Pick your license as you wish (should match "license" above)
        'License :: Other/Proprietary License',

        # Specify the Python versions you support here. In particular, ensure
        # that you indicate whether you support Python 2, Python 3 or both.
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
    ],
)
