ctypedef bint bool
from .cgtypes.cvec3 cimport vec3
from .cgtypes.cmat4 cimport mat4

ctypedef vec3[double] vec3d
ctypedef mat4[double] mat4d

cdef extern from "boundingbox.h" namespace 'support3d' nogil:
    cdef cppclass BoundingBox:
        BoundingBox()
        BoundingBox(const vec3d& min, const vec3d& max)
        
        void clear()
        # Return true if the bounding box is empty.
        bool isEmpty() const
        void getBounds(vec3d& min, vec3d& max) const
        void getBounds(const vec3d& dir, vec3d& min, vec3d& max) const
        void setBounds(const vec3d& min, const vec3d& max)
        vec3d center() const
        void addPoint(const vec3d& p)
        void addBoundingBox(const BoundingBox& bb)
        void transform(const mat4d& M, BoundingBox& bb)
        vec3d clamp(const vec3d& p) const
        void clamp(const vec3d& p, vec3d& target) const