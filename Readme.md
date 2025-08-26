# CyCGkit cgtypes
Vector, quaternion and matrix operations based on the [__Python Computer Graphics Kit 2__](http://cgkit.sourceforge.net/). 

### About the project
This are alternate Python bindings for the "cgtypes" part of the Python CGkit 2, using Cython for compilation to 
avoid the original dependency on Scons and Boost.
 
### Motivations
- I had problems trying to compile the original Python bindings for Python 3.3 to use them with Engendro 3D, 
due to their Boost dependency, and the simplest solution was to create a new binding, this time based on Cython.
- I wanted to add some way to send the data from the mat4 cgtype right to the GPU, instead of having to convert it to 
Numpy before. Having the .pxd file right on hand and/or creating a 'data' member like in Numpy was a clean way to 
do it.

### Included and missing:
There is support for all cgtypes (vec3, vec4, mat3, mat4, quat).
Other modules/tools like scene management/drawing, load/conversion of files and media are omitted.

### About the license
This work (CyCGkit cgtypes) is distributed under the [MIT license](https://opensource.org/licenses/MIT).
The original CGKit library is licenced under the [MPL 1.1 license](https://www.mozilla.org/en-US/MPL/). 
You can find an unmodified copy of the original CGkit source code in the `src/` folder, corresponding to the 
"support library" 
You can also download a copy of the same source code from http://cgkit.sourceforge.net/download.html.

Please read the respective licenses for more info about your rights.

### Installation
1. Install Cython 3 
2. Run `pip install ./` from the source folder where `setup.py` is located.

If you want to compile this project with your own copy of the original CGkit code, replace the contents of `src/` with 
the contents of the original `cgkit-2.0.0/supportlib/src/` folder. Then install as usual.
