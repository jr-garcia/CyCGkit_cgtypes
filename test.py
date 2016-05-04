from __future__ import print_function

try:
    from ExtensionBuilder import build

    build('./')
except ImportError as ie:
    print(str(ie) + ' Used for simpler building of source while testing. Currently unreleased.')

hasNumpy = False
try:
    from numpy import array, asarray

    hasNumpy = True
except ImportError:
    pass

print('\n###################################   VEC 3   ###################################')
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
print(v[0])
print('slice [:2]', v[:2])
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
print('cgckit c-vec3 memory size: {} (3 doubles of size 8 each)'.format(v.cSize))

print('\n###################################   VEC 4   ###################################')
from cycgkit.cgtypes import vec4

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
print('cgckit c-vec4 memory size: {} (4 doubles of size 8 each)'.format(v.cSize))

print('\n###################################   MAT 3   ###################################')
from cycgkit.cgtypes import mat3

m = mat3([0, 1, 2])
print(m)
m = mat3(vec3(0, 1, 2), vec3(3, 4, 5), vec3(6, 7, 8))
print('from 3 vec3:\n', m)
r0, r1, r2 = m
m = mat3(x)
m = mat3([x] * 9)
m = mat3([45, 45, 45], [45, 45, 45], [153, 153, 153])
print('from 3 lists of 3\n', m)
'''
(45, 45, 153)
(45, 45, 153)
(45, 45, 153)

'''
m = mat3(m)

print('index[0]:', m[0])
print('index[0, 2]:', m[0, 2])

if hasNumpy:
    arr = asarray(m)
    print('numpy.asarray (__getbuffer__):\n', arr)
    arr[0:2] = 3.0
    print('modified from numpy:\n', m)
    m = mat3(arr)
    arr = None

print('multiply')
m = mat3(3, 3, 9)
print(m * 453, '\n')
print(m * 3.0, '\n')
# print(3 * m, '\n')
print(m * vec3(3), '\n')
print(vec3(3) * m, '\n')
print('Dot product:\n', m * m)
try:
    print(m * 'g')
except TypeError as t:
    print(t)

print('Divide', m)
print(m / 53.0, '\n')
print(m / 3)
try:
    print(3 / m)
except TypeError as t:
    print('Exception \'{}\''.format(t))
try:
    m / 0
except ZeroDivisionError as t:
    print('Divide by 0: Exception \'{}\''.format(t))
try:
    print('divide', m / m)
except TypeError as t:
    print('Exception \'{}\''.format(t))

print('modulo %')
print(m % m, '\n')
print(m % 2)
print('add:', m + m)
print('substract:', m - m)
print('negate:', -m)
print('equals (true): ', m == m)
print('equals (false): ', m == mat3(2))
print('not equal (false): ', m != m)
print('not equal (true): ', m != mat3(2))
try:
    m > mat3(1)
except TypeError as ex:
    print('greater (exception):', ex)
# print('ortho:', m.ortho())
print('mat3 memory size:', m.__sizeof__())
print('cgckit c-mat3 memory size: {} (9 doubles of size 8 each)'.format(m.cSize))
print('set [0:3:2] = [-3.0, -3.0, -3.0]:')
m[0:3:2] = vec3(-3)
print(m)
print('set [1, 2] = [-11.0, -11.0, -11.0]:')
m[1, 2] = vec3(-11)
print(m)
print('set [1, 2] = 12.0:')
m[1, 2] = -12
print(m)
if hasNumpy:
    try:
        arr = asarray(m)
        m[2] = vec3(0)
    except ValueError as ex:
        print('Exception if changing while viewed:', ex)
    finally:
        arr = None

m = mat3.identity()
print('identity:\n{}'.format(m))
print('getRow 0 / setRow 0:')
vec = vec3()
m.getRow(0, vec)
vec[0, 2] = 4
m.setRow(0, vec)
print(m)
print('get row 0 as (a, b, c):', m.getRow(0))

print('getColumn 2 / setColumn 2:')
# vec = vec3()
m.getColumn(2, vec)
vec[0, 2] = -6
m.setColumn(2, vec)
print(m)
print('get Column 2 as (a, b, c):', m.getColumn(2))

print('getDiag / setDiag:')
# vec = vec3()
m.getDiag(vec)
vec[2] = 5.077
m.setDiag(vec)
print(m)
print('get Diag as (a, b, c):', m.getDiag())
print('Get value \'at\' [2,0]:', m.at(2, 0))
print(m[2, 0])
print('get rotation ZXY:', m.getRotationZXY())
print('set rotation:\n', m.rotation(10, vec3(10, 20, 0.6)))
m.setRotationXYZ(0, 1, 2)
print('set rotation XYZ:\n', m)
print('mat from.. to.. rotation:\n', mat3.fromToRotation(vec3(0, 0, 20), vec3(10, 0, 0)))
print('set scaling = 10:\n', mat3.scaling(vec3(10, 10, 10)))
m = mat3(1)
m.rotate(20, vec3(10, 20, 0.6))
print('rotate:')
print(m)
m.scale(vec3(10, 10, 10))
print('scale by 10:')
print(m)
rot, sca = m.decompose()
print('\ndecompose to\n- Rotation mat3:\n{}\n- scale vec3:\n{}'.format(rot, sca))
