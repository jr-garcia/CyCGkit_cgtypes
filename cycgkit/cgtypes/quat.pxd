cimport cmat4 as m4
ctypedef m4.mat4[double] mat4_f

cimport cmat3 as m3
ctypedef m3.mat3[double] mat3_f

cimport cvec3 as v3
ctypedef v3.vec3[double] vec3_f

cimport cquat as qu
ctypedef qu.quat[double] quat_f

from vec3 cimport vec3
from vec4 cimport vec4
from mat3 cimport mat3
from mat4 cimport mat4

cdef class quat:
    cdef quat_f cvec
    cdef unsigned short items
    cdef double epsilon

    @staticmethod
    cdef quat from_cvec(quat_f cvec)