cimport cmat3 as m3
ctypedef m3.mat3[double] mat3_f

cimport cvec3 as v3
ctypedef v3.vec3[double] vec3_f

from vec3 cimport vec3

cdef class mat3:
    cdef mat3_f cvec
    cdef unsigned short items
    cdef unsigned int view_count
    cdef bint isTransposed

    cdef Py_ssize_t ncols
    cdef Py_ssize_t nrows
    cdef Py_ssize_t shape[2]
    cdef Py_ssize_t strides[2]

    @staticmethod
    cdef mat3_f from_3iterable_of3(object it3)

    @staticmethod
    cdef mat3_f from_1iterable_of3(object it3)

    @staticmethod
    cdef mat3_f from_9double(object it9)

    @staticmethod
    cdef mat3 from_cvec(mat3_f cvec)

    cdef checkViews(self)

    cdef tuple getRot(mat3 self, bint a=*, bint b=*, bint c=*, bint d=*, bint e=*, bint f=*)
