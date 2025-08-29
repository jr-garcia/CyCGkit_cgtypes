from setuptools import Extension, setup
from Cython.Build import cythonize
from sys import platform

from distutils.sysconfig import get_config_vars
import os

base_folder = os.path.dirname(__file__)

DESCRIPTION = 'Vector, quaternion and matrix operations based on the Python Computer Graphics Kit 2.'

(opt,) = get_config_vars('OPT')
if opt:
    os.environ['OPT'] = " ".join(flag for flag in opt.split() if flag != '-Wstrict-prototypes')

incl = ['./include']
extra_compile = []

if platform == 'win32':
    rldirs = []
    extra_compile.append('/EHsc')
elif platform == 'darwin':
    rldirs = []
else:
    rldirs = ["$ORIGIN"]
    extra_compile.extend(["-w", "-Ofast", '-std=c++14'])


def getVersion():
    init_path = os.path.join(base_folder, 'cycgkit', '__init__.py')
    with open(init_path) as verFile:
        lines = verFile.readlines()
    for line in lines:
        if line.startswith('__version__'):
            return line.split('=')[1].strip(' \'\n\r\t-')


def getLongDescription():
    desc_path = os.path.join(base_folder, 'Readme.md')
    try:
        with open(desc_path) as doc:
            md = doc.read()
        return md
    except Exception as err:
        from warnings import warn
        warn('Error retrieving description: ' + str(err))
        return DESCRIPTION


setup(
        name="CyCGkit cgtypes",
        author='Javier R. García',
        version=getVersion(),
        description=DESCRIPTION,
        long_description=getLongDescription(),
        long_description_content_type='text/markdown',
        url='https://github.com/jr-garcia/CyCGkit_cgtypes',
        license='MIT',
        classifiers=['Development Status :: 5 - Production/Stable',
                     'Intended Audience :: Developers',
                     'Programming Language :: Cython',
                     'Programming Language :: Python :: 3.8',
                     'Programming Language :: Python :: 3.9',
                     'Programming Language :: Python :: 3.10',
                     'Programming Language :: Python :: 3.11',
                     'Programming Language :: Python :: 3.12',
                     'Programming Language :: Python :: Implementation :: CPython',
                     'Programming Language :: Python :: Implementation :: PyPy',
                     'Topic :: Games/Entertainment',
                     'Topic :: Multimedia :: Graphics :: 3D Modeling',
                     'Topic :: Multimedia :: Graphics :: 3D Rendering',
                     'Topic :: Scientific/Engineering :: Mathematics',
                     'Topic :: Software Development :: Libraries'],
        keywords='3d,model,geometry,cgkit,videogames,cython,math,vector,quaternion,matrix',
        install_requires=['cython'],
        packages=["cycgkit", 'cycgkit.cgtypes'],
        ext_modules=cythonize([
            Extension('cycgkit.cgtypes.*', ["./cycgkit/cgtypes/*.pyx", './src/vec3.cpp'],
                      include_dirs=incl,
                      runtime_library_dirs=rldirs,
                      extra_compile_args=extra_compile,
                      language="c++"),
            Extension('cycgkit.boundingbox', ["cycgkit/boundingbox.pyx", './src/boundingbox.cpp', './src/vec3.cpp'],
                      include_dirs=incl,
                      runtime_library_dirs=rldirs,
                      extra_compile_args=extra_compile,
                      language="c++")
        ],
            compiler_directives={
                'c_string_type': 'bytes',
                'c_string_encoding': 'utf8',
                'language_level': 3,
            }
        ),
)
