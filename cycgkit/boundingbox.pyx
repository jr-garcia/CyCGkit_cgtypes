cimport cBoundingBox as cbb
from cgtypes.vec3 cimport vec3
from cgtypes cimport cvec3
from cgtypes.mat4 cimport mat4
from cgtypes cimport cmat4
from cython.operator cimport dereference as deref

ctypedef fused T:
    float
    double


cdef class BoundingBox:
    '''Axis aligned bounding box.'''
    cdef cbb.BoundingBox* thisptr

    def __init__(self, vec3 min=None, vec3 max=None):
        if min is None and max is None:
            self.thisptr = new cbb.BoundingBox()
        else:
            self.thisptr = new cbb.BoundingBox(min.cvec, max.cvec)

    def __dealloc__(self):
        del self.thisptr
    
    def __repr__(self):
        cdef str ret = "<BoundingBox: "
        if (self.thisptr.isEmpty()):
            ret += "empty>"
        else:
            bmin, bmax = self.getBounds()
            ret += str(bmin) + " - " + str(bmax) + ">"
        return ret

    def clear(self):
        '''
        Make the bounding box empty
        '''
        self.thisptr.clear()

    def isEmpty(self):
        '''
	    isEmpty() -> Bool\n\n
	    Return True if the bounding box is empty.)
        '''
        return self.thisptr.isEmpty()

    def getBounds(self, vec3 dir=None):
        '''
        getBounds([dir]) ->(bmin, bmax)\n\n
        Return the minimum and maximum bound. The bounds are returned as\n
        vec3 objects. dir is may be a vec3 that controls what corners will\n
        be returned.)
        '''
        cdef cbb.vec3d min, max
        if dir is not None:
            self.thisptr.getBounds(dir.cvec, min, max)
        else:
            self.thisptr.getBounds(min, max)
        return vec3.from_cvec(min), vec3.from_cvec(max)

    def setBounds(self, vec3 b1, vec3 b2):
        '''
	    setBounds(b1, b2)\n\n
        Set new bounds for the bounding box. The rectangle given\n
        by b1 and b2 defines the new bounding box.)
        '''
        self.thisptr.setBounds(b1.cvec, b2.cvec)

    def center(self):
        '''
	    center() -> vec3\n\n
	    Return the center of the bounding box.)
        '''
        return vec3.from_cvec(self.thisptr.center())

    def addPoint(self, vec3 p):
        '''
        addPoint(p)\n\n
        Enlarge the bounding box so that the point p is enclosed in the box.)
	    '''
        self.thisptr.addPoint(p.cvec)

    def addBoundingBox(self, BoundingBox bb):
        '''
        addBoundingBox(bb)\n\n
        Enlarge the bounding box so that the bounding box bb is enclosed in\n
        the box.)
        '''
        self.thisptr.addBoundingBox(deref(bb.thisptr))

    def transform(self, mat4 M):
        '''
        transform(M) -> BoundingBox\n\n
        Returns a transformed bounding box. The transformation is given by M\n
        which must be a mat4. The result will still be axis aligned, so the\n
        volume will not be preserved.)
        '''
        cdef cbb.BoundingBox bb
        cdef cbb.vec3d min, max
        self.thisptr.transform(M.cvec, bb)
        bb.getBounds(min, max)
        return BoundingBox(vec3.from_cvec(min), vec3.from_cvec(max))

    def clamp(self, vec3 p):
        '''
        clamp(p) -> vec3\n\n
        Clamp a point so that it lies within the bounding box.)
        '''
        return vec3.from_cvec(self.thisptr.clamp(p.cvec))
