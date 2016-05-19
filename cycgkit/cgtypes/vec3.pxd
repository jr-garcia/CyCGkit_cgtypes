cimport cvec3 as v3
ctypedef v3.vec3[double] vec3_f

cimport cvec4 as v4
ctypedef v4.vec4[double] vec4_f

cimport cmat3 as m3
ctypedef m3.mat3[double] mat3_f
from mat3 cimport mat3

cimport cmat4 as m4
ctypedef m4.mat4[double] mat4_f
from mat4 cimport mat4


cdef class vec3:
    cdef vec3_f cvec
    cdef unsigned short items
    cdef readonly double epsilon

    @staticmethod
    cdef vec3 from_cvec(vec3_f cvec)

    cdef vec3_f mat3Mul(vec3 self, mat3_f M)

    cdef vec3_f mat4Mul(vec3 self, mat4_f M)

