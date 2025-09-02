import unittest
from cycgkit.cgtypes import vec3, vec4, mat3, mat4, quat
from cycgkit.cgtypes.quat import slerp

# Check if numpy is available
hasNumpy = True
try:
    import numpy as np
except ImportError:
    hasNumpy = False


class TestCyCgKitTypes(unittest.TestCase):
    def setUp(self):
        self.v3 = vec3(9, 2, 5)
        self.v4 = vec4(9, 2, 5, 10)
        self.m3 = mat3([45, 45, 45], [45, 45, 45], [153, 153, 153])
        self.m4 = mat4.lookAtRH(vec3(), vec3(1.4, 0.5, 0))

    def test_vec3_initialization(self):
        # Test various vector initialization methods
        self.assertEqual(tuple(vec3(9, 2, 5)), (9, 2, 5))
        self.assertEqual(tuple(vec3([9, 2, 5])), (9, 2, 5))
        self.assertEqual(tuple(vec3(self.v3)), (9, 2, 5))

    def test_vec3_indexing(self):
        self.assertEqual(self.v3[0], 9)
        self.assertEqual(self.v3.x, 9)
        self.assertEqual(tuple(self.v3[:2]), (9, 2))

    def test_vec3_arithmetic(self):
        # Multiplication
        self.assertEqual(tuple(self.v3 * 3), (27, 6, 15))
        self.assertEqual(tuple(self.v3 * 3.0), (27, 6, 15))

        # Division
        self.assertEqual(tuple(self.v3 / 3), (3, 2 / 3, 5 / 3))

        # Dot product
        self.assertEqual(self.v3 * self.v3, 110)

        # Cross product
        cross_result = vec3(1, 2, 3) ^ self.v3
        self.assertIsInstance(cross_result, vec3)

        self.assertEqual(cross_result, vec3(4, 22, -16))

    def test_vec3_comparisons(self):
        self.assertTrue(self.v3 == self.v3)
        self.assertFalse(self.v3 == vec3(0, 1, 2))
        self.assertTrue(self.v3 > vec3(0, 1, 2))
        self.assertTrue(self.v3 >= vec3(0, 1, 2))

    def test_vec3_methods(self):
        # Normalization
        normalized = self.v3.normalized()
        self.assertAlmostEqual(normalized.length, 1.0)

        # Length
        self.assertEqual(len(self.v3), 3)

        # Max/Min methods
        self.assertEqual(self.v3.max(), 9)
        self.assertEqual(self.v3.min(), 2)
        self.assertEqual(self.v3.maxIndex(), 0)
        self.assertEqual(self.v3.minIndex(), 1)

    def test_vec4_initialization(self):
        self.assertEqual(tuple(vec4(9, 2, 5, 10)), (9, 2, 5, 10))

    def test_mat3_initialization(self):
        # Test various matrix initialization methods
        m = mat3([0, 1, 2])
        self.assertEqual(len(m), 9)

        m2 = mat3(self.v3, vec3(3, 4, 5), vec3(6, 7, 8))
        self.assertIsInstance(m2, mat3)

    def test_mat3_operations(self):
        # Multiplication
        m = mat3(3, 3, 9)
        self.assertIsInstance(m * 3, mat3)
        self.assertIsInstance(m * vec3(3), vec3)

        # Identity matrix
        identity = mat3.identity()
        self.assertEqual(identity[0, 0], 1)
        self.assertEqual(identity[1, 1], 1)
        self.assertEqual(identity[2, 2], 1)

    def test_mat3_transformations(self):
        # Rotation
        rotation = mat3().setRotation(10, vec3(10, 20, 0.6))
        self.assertIsInstance(rotation, mat3)

        # Scaling
        scaling = mat3.scaling(vec3(10, 10, 10))
        self.assertIsInstance(scaling, mat3)

    def test_quat_operations(self):
        q1 = quat()
        q2 = quat(123)

        # Slerp interpolation
        slerp_result = slerp(0.222, q1, q2)
        self.assertIsInstance(slerp_result, quat)

        # Quaternion from matrix
        rot_mat = mat3()
        rot_mat.setRotation(3.1415 / 4, vec3(0, 1, 0))
        q_from_mat = quat()
        q_from_mat.fromMat(rot_mat)
        self.assertIsInstance(q_from_mat, quat)
        new_mat = q_from_mat.toMat3()
        self.assertEqual(new_mat, rot_mat)

    def test_error_handling(self):
        # Test type errors and division errors
        with self.assertRaises(TypeError):
            self.v3 * 'g'

        with self.assertRaises(TypeError):
            self.v3 / self.v3

        with self.assertRaises(ZeroDivisionError):
            self.m3 / 0

    @unittest.skipIf(not hasattr(unittest, 'skipIf'), "Skip decorator not available")
    @unittest.skipUnless(hasNumpy, "Numpy not installed")
    def test_vec3_numpy_initialization(self):
        x, y, z = 9, 2, 5
        # Test initialization from numpy array
        arr = np.array([x, y, z])
        v = vec3(arr)

        self.assertEqual(tuple(v), (x, y, z))
        self.assertIsInstance(v, vec3)

    @unittest.skipIf(not hasattr(unittest, 'skipIf'), "Skip decorator not available")
    @unittest.skipUnless(hasNumpy, "Numpy not installed")
    def test_vec4_numpy_initialization(self):
        x, y, z, w = 9, 2, 5, 10
        # Test initialization from numpy array
        arr = np.array([x, y, z, w])
        v = vec4(arr)

        self.assertEqual(tuple(v), (x, y, z, w))
        self.assertIsInstance(v, vec4)

    @unittest.skipIf(not hasattr(unittest, 'skipIf'), "Skip decorator not available")
    @unittest.skipUnless(hasNumpy, "Numpy not installed")
    def test_mat3_numpy_compatibility(self):
        # Test numpy array conversion and modification
        m = mat3([45, 45, 45], [45, 45, 45], [153, 153, 153])

        # View as numpy array
        arr = np.asarray(m)
        self.assertIsInstance(arr, np.ndarray)
        self.assertEqual(arr.shape, (3, 3))

        # Modify numpy array
        np.fill_diagonal(arr, 3.0)

        # Check if matrix reflects numpy modifications
        for i in range(3):
            self.assertAlmostEqual(m[i, i], 3.0)

        # Reconstruct matrix from numpy array
        m2 = mat3(arr)
        self.assertIsInstance(m2, mat3)

    @unittest.skipIf(not hasattr(unittest, 'skipIf'), "Skip decorator not available")
    @unittest.skipUnless(hasNumpy, "Numpy not installed")
    def test_numpy_view_modification_exception(self):
        m = mat3([45, 45, 45], [45, 45, 45], [153, 153, 153])

        # Test exception when trying to modify while viewed
        _ = np.asarray(m)
        with self.assertRaises(ValueError):
            m[2] = vec3(0)


if __name__ == '__main__':
    unittest.main()
