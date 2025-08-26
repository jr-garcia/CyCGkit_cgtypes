from . cimport cmat4 as m4
ctypedef m4.mat4[double] mat4_f

from . cimport cmat3 as m3
ctypedef m3.mat3[double] mat3_f

from . cimport cvec3 as v3
ctypedef v3.vec3[double] vec3_f

from . cimport cvec4 as v4
ctypedef v4.vec4[double] vec4_f

from .vec3 cimport vec3
from .vec4 cimport vec4
from .mat3 cimport mat3


cdef class mat4:
    cdef mat4_f cmat
    cdef unsigned short items
    cdef unsigned int view_count
    cdef bint isTransposed

    cdef Py_ssize_t ncols
    cdef Py_ssize_t nrows
    cdef Py_ssize_t shape[2]
    cdef Py_ssize_t strides[2]

    @staticmethod
    cdef mat4_f from_4iterable_of4(object it4)

    @staticmethod
    cdef mat4_f from_1iterable_of4(object it4)

    @staticmethod
    cdef mat4_f from_16double(object it16)

    @staticmethod
    cdef mat4 from_cmat(mat4_f cmat)

    cdef checkViews(self)
