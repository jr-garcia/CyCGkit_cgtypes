import unittest
from unittest import TestCase, skip, skipIf
import cycgkit.cgtypes as cycg
from cycgkit import boundingbox as cybb

try:
    import cgkit.cgtypes as cg
    from cgkit import boundingbox as cgbb
except ImportError:
    pass

from _skip_helper import skip_if_package_missing


@skip_if_package_missing('cgkit')
class test(TestCase):
    def setUp(self):
        a = 0, 1.6, 2, 3, 4.977, 5, 6, .007, 8, 0, 1.6, 2, 3, 4.977, 5, 6
        b = 0.000921, 10, 20.5, -34.5
        self.cym = cycg.mat4(*a)
        self.cgm = cg.mat4(*a)
        self.cyvec4 = cycg.vec4(*b)
        self.cgvec4 = cg.vec4(*b)
        self.cyvec3 = cycg.vec3(2, -4, .8)
        self.cgvec3 = cg.vec3(2, -4, .8)
        self.cyb = cybb.BoundingBox(-self.cyvec3, self.cyvec3)
        self.cgb = cgbb.BoundingBox(-self.cgvec3, self.cgvec3)

    def assertEqual(self, first, second, msg=None):
        first = repr(first)
        second = repr(second)
        super(test, self).assertEqual(first, second, msg)

    def test_repr(self):
        cybstr = repr(self.cyb)
        cgbstr = repr(self.cgb)
        self.assertEqual(cybstr, cgbstr)

    def test_SameReturnCenter(self):
        a = self.cgb.center()
        b = self.cyb.center()
        self.assertEqual(a, b)

    def test_empty(self):
        self.assertTrue(cybb.BoundingBox().isEmpty() == cgbb.BoundingBox().isEmpty())

    def test_nonEmpty(self):
        self.assertTrue(self.cyb.isEmpty() == self.cgb.isEmpty())


if __name__ == '__main__':
    unittest.main()
