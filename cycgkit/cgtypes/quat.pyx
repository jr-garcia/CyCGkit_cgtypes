cdef _supported_ = ['list with 4 numbers',
                         '1 vec4',
                         'quat',
                         '1 number',
                         '4 numbers',
                         '1-D numpy array',
                         'empty args']

ctypedef fused anymat:
        mat3
        mat4


cdef class quat:
    def __cinit__(self, *args):
        cdef short argLen = len(args)
        cdef type otype = type(args[0]) if argLen > 0 else None
        self.items = 4
        self.epsilon = vec3_f().epsilon

        if argLen == 0:
            # no arguments
            self.cvec = quat_f()
        elif otype is quat:
            # copy from quat
            self.cvec = (<quat>args[0]).cvec
        elif 'numpy.ndarray' in str(otype):
            # from numpy array
            if args[0].ndim == 1:
                self.cvec = quat_f(args[0], args[1], args[2], args[3])
            else:
                raise TypeError('for quaternions, Numpy arrays should be 1-D')
        elif otype is vec4:
            # from vec4
            if argLen == 1:
                # 1 vec
                self.cvec = quat_f((<vec4>args[0]).cvec[0], (<vec4>args[0]).cvec[1],
                                   (<vec4>args[0]).cvec[2], (<vec4>args[0]).cvec[3])
            else:
                raise TypeError('Wrong number of arguments. Expected 1 vec4 got {}'.format(len(args)))
        elif argLen == self.items:
            # from 4 explicit doubles or ints
            self.cvec = self.cvec = quat_f(args[0], args[1], args[2], args[3])
        elif argLen == 1 and type(args[0]) in [int, float]:
            # from 1 repeated double or int
            self.cvec = quat_f(<double>args[0])
        elif argLen == 1 and otype is list:
            # from list with unknown stuff inside
            self.cvec = quat(*args[0]).cvec
        else:
            raise TypeError('Wrong number/type of arguments. Expected one of the following:\n{}\ngot {} {}'.format(
                '\n'.join(['- ' + str(s) for s in _supported_]), argLen, otype))

    @staticmethod
    cdef quat from_cvec(quat_f cvec):
        cdef quat res = quat()
        res.cvec = cvec
        return res

    def __mul__(self, other):
        cdef quat_f res
        cdef type stype = type(self)
        cdef type otype = type(other)
        if stype == quat and otype in [float, int]:
            res = <quat_f&>self.cvec * <double>other
        elif stype == quat and otype == quat:
            res = <quat_f&>other.cvec * <quat_f&>self.cvec
        if otype in [float, int] and otype == quat:
            res = (<quat_f&>self.cvec).mul(<double>other, <quat_f&>self.cvec)
        else:
            raise TypeError("unsupported operand type(s) for *: \'{}\' and \'{}\'".format(quat, otype))

        return quat.from_cvec(res)

    def __truediv__(quat self, other not None):
        cdef quat_f res
        cdef type otype = type(other)
        if type(self) is not quat and otype is quat:
            raise TypeError('quat in the right not supported')
        if otype in [float, int]:
            if other == 0:
                raise ZeroDivisionError("can't divide by 0")
            else:
                res = (<quat_f&>(self).cvec) / (<const double>other)
                return quat.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(quat, otype))

    def __div__(self, other not None):
        return self.__truediv__(other)

    def __neg__(self):
        cdef quat res = quat()
        res.cvec = -(<quat_f>self.cvec)
        return res

    def __sub__(self, other not None):
        """ Return self-value. """
        cdef quat_f res
        cdef type otype = type(other)
        if otype is quat:
            res = (<quat_f&>(<quat>self).cvec) - (<quat_f&>(<quat>other).cvec)
            return quat.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for -: \'{}\' and \'{}\'".format(quat, otype))

    def __add__(self, other not None):
        """ Return self+value. """
        cdef quat_f res
        cdef type otype = type(other)
        if otype is quat:
            res = (<quat_f&>(<quat>self).cvec) + (<quat_f&>(<quat>other).cvec)
            return quat.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for +: \'{}\' and \'{}\'".format(quat, otype))

    def __richcmp__(quat self, quat other, int f):
        cdef str op
        if f == 0:
            op = '<'
        elif f == 1:
            op = '<='
        if f == 2:
            return self.cvec == other.cvec
        elif f == 3:
            return self.cvec != other.cvec
        elif f == 4:
            op = '>'
        elif f == 5:
            op = '>='

        raise TypeError('operator \'{}\' not defined for {}'.format(op, quat))

    def __len__(quat self):
        return self.items

    def __getitem__(self, object index):
        cdef type otype = type(index)
        if otype is int or otype is slice:
            return [self.cvec.w, self.cvec.x, self.cvec.y, self.cvec.z][index]
        else:
            raise TypeError('an integer is required')

    def __setitem__(quat self, object key, double value):
        cdef type otype = type(key)
        cdef list its = []
        cdef object val
        if otype is int:
            if key > self.items - 1:
                raise IndexError(key)
            else:
                its.append(key)
        elif otype is slice:
            for r in range(key.start, key.stop, key.step if key.step is not None else 1):
                its.append(r)
        elif otype == tuple:
            for r in key:
                its.append(r)
        else:
            raise TypeError('an integer is required')
        for r in its:
            if r == 0:
                self.cvec.w = value
            elif r == 1:
                self.cvec.x = value
            elif r == 2:
                self.cvec.y = value
            elif r == 3:
                self.cvec.z = value
            else:
                raise IndexError(r)

    def __repr__(self):
        cdef double wf = round(self.cvec.w, 3)
        cdef double xf = round(self.cvec.x, 3)
        cdef double yf = round(self.cvec.y, 3)
        cdef double zf = round(self.cvec.z, 3)
        cdef object w, x, y, z
        w = int(wf) if int(wf) == round(wf, 3) else round(wf, 3)
        x = int(xf) if int(xf) == round(xf, 3) else round(xf, 3)
        y = int(yf) if int(yf) == round(yf, 3) else round(yf, 3)
        z = int(zf) if int(zf) == round(zf, 3) else round(zf, 3)
        return '({}, {}, {}, {})'.format(w, x, y, z)

    def __sizeof__(self):
        return sizeof(quat)

    property cSize:
        "Size in memory of c native elements"
        def __get__(self):
            return sizeof(self.cvec)

    property w:
        "-"
        def __get__(self):
            return self.cvec.w

        def __set__(self, value):
           self.cvec.w = value

    property x:
        "-"
        def __get__(self):
            return self.cvec.x

        def __set__(self, value):
            self.cvec.x = value

    property y:
       "-"
       def __get__(self):
           return self.cvec.y

       def __set__(self, value):
           self.cvec.y = value

    property z:
       "-"
       def __get__(self):
           return self.cvec.z

       def __set__(self, value):
           self.cvec.z = value

    ########################  QUAT METHODS  ########################

    def __abs__(quat self):
        return self.cvec.abs()

    def normalized(quat self):
        '''Return a normalized copy of this quaternion'''
        if self.length <= self.epsilon:
            raise ZeroDivisionError("divide by zero");
        return quat.from_cvec(self.cvec.normalize())

    def normalize(quat self):
        '''Normalize this quaternion'''
        if self.length <= self.epsilon:
            raise ZeroDivisionError("divide by zero");
        self.cvec.normalize(self.cvec)

    def dot(quat self, quat q):
        return self.cvec.dot(q.cvec)

    def conjugated(quat self):
        '''Returns a copy of this quat conjugate'''
        return quat.from_cvec(self.cvec.conjugate())

    def conjugate(quat self):
        '''Conjugate this quat in place'''
        self.cvec.conjugate(self.cvec)

    def inversed(quat self):
        '''Returns a copy of this quat inverse'''
        return quat.from_cvec(self.cvec.inverse())

    def inverse(quat self):
        '''Invert this quat in place'''
        self.cvec.inverse(self.cvec)

    @staticmethod
    def fromMat(anymat mat):
        cdef quat_f res = quat_f()
        return quat.from_cvec(res.fromMat(mat.cvec))

    def toMat3(quat self):
        cdef mat3_f ret = self.cvec.toMat3()
        return mat3.from_cvec(ret)

    def toMat4(quat self):
        cdef mat4_f ret = self.cvec.toMat4()
        return mat4.from_cvec(ret)

    def toAngleAxis(quat self):
        cdef double angle = 0
        cdef vec3_f axis
        self.cvec.toAngleAxis(angle, axis)
        return angle, vec3.from_cvec(axis)

    @staticmethod
    def fromAngleAxis(double angle, vec3 axis):
        cdef quat_f res = quat_f()
        return quat.from_cvec(res.fromAngleAxis(angle, axis.cvec))

    def log(quat self):
        return quat.from_cvec(self.cvec.log())

    def exp(quat self):
        return quat.from_cvec(self.cvec.exp())

    def rotateVec(quat self, vec3 v):
        return vec3.from_cvec(self.cvec.rotateVec(v.cvec))

def slerp(double t, quat q0, quat q1, bint shortest=False):
    return quat.from_cvec(qu.slerp(t, q0.cvec, q1.cvec, shortest))

def squad(double t, quat a, quat b,quat c, quat d):
    return quat.from_cvec(qu.squad(t, a.cvec, b.cvec, c.cvec, d.cvec))