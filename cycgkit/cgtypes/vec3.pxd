cimport cvec3 as v3
ctypedef v3.vec3[double] vec3_f

cimport cmat3 as m3
ctypedef m3.mat3[double] mat3_f
from mat3 cimport mat3

cdef class vec3:
    cdef vec3_f cvec
    cdef unsigned short items

    @staticmethod
    cdef vec3 from_cvec(vec3_f cvec)

    cdef vec3_f mat3Mul(vec3 self, mat3_f M)

