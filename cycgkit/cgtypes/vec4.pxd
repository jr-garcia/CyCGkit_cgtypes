cimport cvec3 as v3
cimport cvec4 as v4

ctypedef v3.vec3[double] vec3_f
ctypedef v4.vec4[double] vec4_f

cimport cmat4 as m4
ctypedef m4.mat4[double] mat4_f
from mat4 cimport mat4

cdef class vec4:
    cdef vec4_f cvec
    cdef unsigned short items

    @staticmethod
    cdef vec4 from_cvec(vec4_f cvec)

    cdef vec4_f mat4Mul(vec4 self, mat4_f M)