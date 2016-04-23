cimport cvec3 as v3

ctypedef v3.vec3[double] vec3_f

cdef class vec3:
    cdef vec3_f cvec
    cdef unsigned short items

    @staticmethod
    cdef vec3 from_cvec(vec3_f cvec)

