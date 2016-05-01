# CyCGkit minimal

Small project aimed to create an alternate, Cython based Python binding for _some_ parts of the [__Python Computer 
Graphics Kit 2__](http://cgkit.sourceforge.net/).

### About the license:
This work is distributed under the [MIT license](https://opensource.org/licenses/MIT). However, CGKit is under 
different licenses. We include the CGkit source code under the [MPL license](https://www.mozilla.org/en-US/MPL/) 
and you can also download a copy of the same source code from http://cgkit.sourceforge.net/download.html

Please read respective licenses for more info about your rights.
  
### Motivations:
- I have been having problems trying to compile the original Python bindings for Python 3.3 to use them with 
 Engendro 3D. 
- Needing to install, compile, configure the required Boost-Python in Windows was simply imposible for me the last 
time I tried it, so the simplest solution was to create a new binding, this time based on Cython.
- I wanted to add some way to send the data from the mat4 cgtype right to the GPU, instead of having to convert it to 
Numpy before. Having the .pxd file right on hand and/or creating a 'data' member like in Numpy was a clean way to 
do it.

### Included and missing:
It is planned to add support for all cgtypes (vec3, vec4, mat3, mat4, quat) and for the functions for procedural 
creation of geometry (trimeshgeom, spheregeom, boxgeom and similars).
Other modules/tools like scene management/drawing, load/conversion of files and media will be omitted (unless my 
engine needs those in the future).

#### Currently working:
 - vec3 (working)
 - vec4 (working)
 - mat3 (working)




