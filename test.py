try:
    from ExtensionBuilder import build
    build('./')
except ImportError as ie:
    print(str(ie) + ' Used for simpler building of source while testing. Currently unreleased.')

hasNumpy = False
try:
    from numpy import array
    hasNumpy = True
except ImportError:
    pass

print('###################################   VEC 3   ###################################')
from cycgkit.cgtypes import vec3

v = vec3(9, 2, 5)
x, y, z = v
print(x, y, z)
v = vec3(x)
v = vec3([x, y, z])
v = vec3(v)
if hasNumpy:
    v = vec3(array([x, y, z]))

print('Repr and index[0]')
print(v)
print(v[:2])
print('Prop x')
print(v.x)

print('multiply')
print(v * 453)
print(v * 3.0)
print('Dot product:', v * v)
print('Cross:', v ^ v)
try:
    print(v * 'g')
except TypeError as t:
    print(t)

print('Divide')
print(v / 53.0)
print(v / 3)
try:
    print(3 / v)
except Exception as t:
    print('Exception \'{}\''.format(t))
try:
    vec3(0, 0, 0) / 0
except Exception as t:
    print('Divide by 0: Exception \'{}\''.format(t))
try:
    print('divide', v / v)
except TypeError as t:
    print('Exception \'{}\''.format(t))

print('modulo %')
print(v % v)
print(v % 2)
print('vec3 len:', len(v))
print('vector lenght:', v.length)
print('add:', v + v)
print('substract:', v - v)
print('negate:', -v)
print('equals (true): ', v == v)
print('equals (false): ', v == vec3(0, 1, 2))
print('not equal (false): ', v != v)
print('not equal (true): ', v != vec3(0, 1, 2))
print('greater (true):', v > vec3(0, 1, 2))
print('greater or equal (true): ', v >= vec3(0, 1, 2))
print('less (false):', v < vec3(0, 1, 2))
print('less or equal (false): ', v <= vec3(0, 1, 2))
print('normalized:', v.normalized())
v.normalize()
print('normalize self:', v)
print('ortho:', v.ortho())
print('reflect:', v.reflect(v))
print('refract:', v.refract(v, -1))
print('max/abs/index')
print(v.max())
print(v.maxAbs())
print(v.maxIndex())
print('min/abs/index')
print(v.min())
print(v.minAbs())
print(v.minIndex())
r, theta, phi = v.get_polar()
print('get polar (r, theta, phi):', (r, theta, phi))
v.set_polar(0.2, 0, 0)
print('set polar:', v)
print('vec3 memory size:', v.__sizeof__())
print('cgckit c-vec3 memory size: {} (3 floats of size 4 each)'.format(v.cSize))

from cycgkit.cgtypes import vec4

print('###################################   VEC 4   ###################################')
v = vec4(9, 2, 5, 10)
x, y, z, w = v
print(x, y, z, w)
v = vec4(x)
v = vec4([x, y, z, w])
v = vec4(v)
if hasNumpy:
    v = vec4(array([x, y, z, w]))

print('Repr and index[0]')
print(v)
print(v[0])
print('Prop x')
print(v.x)

print('multiply')
print(v * 453)
print(v * 3.0)
print('Dot product:', v * v)
# print('Cross:', v ^ v)
try:
    print(v * 'g')
except TypeError as t:
    print(t)

print('Divide')
print(v / 53.0)
print(v / 3)
try:
    print(3 / v)
except Exception as t:
    print('Exception \'{}\''.format(t))
try:
    vec3(0, 0, 0) / 0
except Exception as t:
    print('Divide by 0: Exception \'{}\''.format(t))
try:
    print('divide', v / v)
except TypeError as t:
    print('Exception \'{}\''.format(t))

print('modulo %')
print(v % v)
print(v % 2)
print('vec3 len:', len(v))
print('vector lenght:', v.length)
print('add:', v + v)
print('substract:', v - v)
print('negate:', -v)
print('equals (true): ', v == v)
print('equals (false): ', v == vec4(0, 1, 2, 3))
print('not equal (false): ', v != v)
print('not equal (true): ', v != vec4(0, 1, 2, 3))
print('greater (true):', v > vec4(0, 1, 2, 3))
print('greater or equal (true): ', v >= vec4(0, 1, 2, 3))
print('less (false):', v < vec4(0, 1, 2, 3))
print('less or equal (false): ', v <= vec4(0, 1, 2, 3))
print('normalized:', v.normalized())
v.normalize()
print('normalize self:', v)
# print('ortho:', v.ortho())
# print('reflect:', v.reflect(v))
# print('refract:', v.refract(v, -1))
print('max/abs/index')
print(v.max())
print(v.maxAbs())
print(v.maxIndex())
print('min/abs/index')
print(v.min())
print(v.minAbs())
print(v.minIndex())
# r, theta, phi = v.get_polar()
# print('get polar (r, theta, phi):', (r, theta, phi))
# v.set_polar(0.2, 0, 0)
# print('set polar:', v)
print('vec4 memory size:', v.__sizeof__())
print('cgckit c-vec4 memory size: {} (4 floats of size 4 each)'.format(v.cSize))
