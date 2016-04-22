cimport cmat3 as m3
ctypedef m3.mat3[float] mat3_f

cimport cvec3 as v3
ctypedef v3.vec3[float] vec3_f

cdef class mat3:
    cdef mat3_f cvec
    cdef int items

    cdef Py_ssize_t ncols
    cdef Py_ssize_t nrows
    cdef Py_ssize_t shape[2]
    cdef Py_ssize_t strides[2]

    @staticmethod
    cdef mat3 from_cvec(mat3_f cvec)