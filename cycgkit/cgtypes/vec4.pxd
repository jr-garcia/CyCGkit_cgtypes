cimport cvec3 as v3
cimport cvec4 as v4

ctypedef v3.vec3[float] vec3_f
ctypedef v4.vec4[float] vec4_f

cdef class vec4:
    cdef vec4_f cvec
    cdef unsigned short items

    @staticmethod
    cdef vec4 from_cvec(vec4_f cvec)