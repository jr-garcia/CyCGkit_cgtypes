# CyCGkit cgtypes
Vector, quaternion and matrix operations based on the [__Python Computer Graphics Kit 2__](http://cgkit.sourceforge.net/). 

### About the project
These are alternative Python bindings for the "cgtypes" portion of Python CGkit 2, built with Cython to avoid the 
original dependency on SCons and Boost.
 
### Motivations
- I had problems compiling the original Python bindings for Python 3.3 to use with my engine Engendro 3D
  because of their Boost dependency, and the simplest solution was to create new bindings based on Cython.
- I wanted a way to send mat4 data directly to the GPU instead of first converting it to NumPy. 
  Having the .pxd file available and/or adding a 'data' member was a clean solution.

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
1. Run `pip install ./` from the source folder where `setup.py` is located.

   If this fails due to Cython being missing, install Cython 3 and try again.

If you want to compile this project with your own copy of the original CGkit code, replace the contents of `src/` with 
the contents of the original `cgkit-2.0.0/supportlib/src/` folder. Then install as usual.
                     
### Example: Transforming a Point in 3D Space

```python
import math
from cycgkit.cgtypes import vec3, vec4, mat4, quat

# Step 1: Define a point in 3D space
point = vec3(1, 2, 3)

# Step 2: Create a rotation quaternion (rotate 45 degrees around the Y-axis)

angle = math.radians(45)  # Ensure angle is in radians
rotation = quat.fromAngleAxis(angle, vec3(0, 1, 0))

# Step 3: Rotate the point using the quaternion
q = rotation
vq = quat(0.0, point.x, point.y, point.z)
rotated_q = q * vq * q.inversed()
rotated_point = vec3(rotated_q.x, rotated_q.y, rotated_q.z)

# Step 4: Define a translation vector
vector = vec4(5.0, 5.0, 5.0, 1.0)

# Step 5: Create a transformation matrix (rotation + translation)
T = mat4.identity()
angle, axis = rotation.toAngleAxis()
T.setRotation(angle, axis)
T.setColumn(3, vector)

# Step 6: Apply the transformation to the point
transformed_point = T * vec4(rotated_point, 1.0)

print("Original Point:", point)
print("Rotated Point:", rotated_point)
print("Transformed Point:", transformed_point)
```

Check `demo.py` on the repo for more examples.