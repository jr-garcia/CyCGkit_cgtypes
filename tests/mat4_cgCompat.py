import unittest
from unittest import TestCase, skip, skipIf
import cycgkit.cgtypes as cycg
import cgkit.cgtypes as cg

try:
    import numpy as np

    hasNumpy = True
except ImportError:
    hasNumpy = False


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

    def assertEqual(self, first, second, msg=None):
        types = [type(self.cgm), cg._core.mat4, type(self.cym)]
        if type(first) in types and type(second) in types:
            first = first.toList()
            second = second.toList()
            self.assertSequenceEqual(first, second, msg, seq_type=list)
        else:
            super(test, self).assertEqual(first, second, msg)

    def test_from16floats(self):
        m1 = cg.mat4(0, 1.6, 2, 3, 4.977, 5, 6, .007, 8, 0, 1.6, 2, 3, 4.977, 5, 6)
        m2 = cycg.mat4(0, 1.6, 2, 3, 4.977, 5, 6, .007, 8, 0, 1.6, 2, 3, 4.977, 5, 6)
        self.assertEqual(m1, m2)

    def test_from4lists(self):
        m1 = cg.mat4([0, 1.6, 2, 3], [4.977, 5, 6, .007], [8, 0, 1.6, 2], [3, 4.977, 5, 6])
        m2 = cycg.mat4([0, 1.6, 2, 3], [4.977, 5, 6, .007], [8, 0, 1.6, 2], [3, 4.977, 5, 6])
        self.assertEqual(m1, m2)

    def test_toListRow(self):
        self.assertEqual(self.cgm.toList(True), self.cym.toList(True))

    def test_toListNotRow(self):
        self.assertEqual(self.cgm.toList(False), self.cym.toList(False))

    def test_indexSimple0(self):
        self.assertEqual(list(self.cgm[0]), list(self.cym[0]))

    def test_indexSimple1(self):
        self.assertEqual(list(self.cgm[1]), list(self.cym[1]))

    def test_indexSimple2(self):
        self.assertEqual(list(self.cgm[2]), list(self.cym[2]))

    def test_indexSimple3(self):
        self.assertEqual(list(self.cgm[2]), list(self.cym[2]))

    def test_indexSubindex0(self):
        index = [0, 0]
        self.assertEqual(self.cgm[index[0], index[1]], self.cym[index[0], index[1]])

    def test_indexSubindex1(self):
        index = [0, 1]
        self.assertEqual(self.cgm[index[0], index[1]], self.cym[index[0], index[1]])

    def test_indexSubindex2(self):
        index = [0, 2]
        self.assertEqual(self.cgm[index[0], index[1]], self.cym[index[0], index[1]])

    def test_indexSubindex3(self):
        index = [0, 3]
        self.assertEqual(self.cgm[index[0], index[1]], self.cym[index[0], index[1]])

    def test_indexTuple(self):
        index = [0, 2]
        self.assertEqual(self.cgm[index[0], index[1]], self.cym[index[0], index[1]])

    def test_repr(self):
        cystr = str(self.cym)
        cgstr = str(self.cgm)
        self.assertEqual(cgstr, cystr)

    def test_multVec4Left(self):
        v1 = self.cgm * self.cgvec4
        v2 = self.cym * self.cyvec4
        self.assertEqual(list(v1), list(v2))

    def test_multVec4Right(self):
        v1 = self.cgvec4 * self.cgm
        v2 = self.cyvec4 * self.cym
        self.assertEqual(list(v1), list(v2))

    def test_multVec3Left(self):
        v1 = self.cgm * self.cgvec3
        v2 = self.cym * self.cyvec3
        self.assertEqual(list(v1), list(v2))

    def test_multVec3Right(self):
        v1 = self.cgvec3 * self.cgm
        v2 = self.cyvec3 * self.cym
        self.assertEqual(list(v1), list(v2))

    @skipIf(not hasNumpy, 'toNumpyArray test skipped. Numpy not found.')
    def test_toNumpyArray(self):
        cgarr = np.asarray(self.cgm)
        cyarr = np.asarray(self.cym)
        self.assertTrue(np.all(np.equal(cgarr, cyarr)))

    def test_lookAt(self):
        v1 = self.cgm.lookAt(cg.vec3(), self.cgvec3)
        v2 = self.cym.lookAt(cycg.vec3(), self.cyvec3)
        self.assertEqual(v1, v2)

    def test_lookAtAlt(self):
        v1 = self.cgm.lookAt(cg.vec3(), self.cgvec3, cg.vec3(0, 1, 0))
        v2 = self.cym.lookAtRH(cycg.vec3(), self.cyvec3, cycg.vec3(0, 1, 0))
        try:
            self.assertEqual(v1, v2)
            raise AssertionError('CGkit\'s lookAt and CyCGkit\'s lookAtRH return same result.')
        except AssertionError:
            return

if __name__ == '__main__':
    unittest.main()
