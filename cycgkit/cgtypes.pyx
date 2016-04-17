cimport cvec3 as v3

ctypedef v3.vec3[float] vec3_f

cdef class vec3:
    cdef vec3_f cvec
    cdef int items

    def __cinit__(self, *args):
        cdef float x, y, z
        cdef list argsl
        self.items = 3
        if args.__len__() == 0:
            self.cvec = vec3_f(0, 0, 0)
            return

        if getattr(args[0], '__getitem__', None):
            if str(type(args[0])) == "<class 'numpy.ndarray'>" and args[0].ndim > 1:
                raise TypeError('for vectors, Numpy arrays should be 1-D')
            argsl = list(args[0])
        else:
            argsl = list(args)
        if len(argsl) >= self.items:
            x = argsl[0]
            y = argsl[1]
            z = argsl[2]
        elif type(argsl[0]) in [int, float]:
            x = y = z = argsl[0]
        self.cvec = vec3_f(x, y, z)

    @staticmethod
    cdef vec3 from_cvec(vec3_f cvec):
        cdef vec3 res = vec3()
        res.cvec = cvec
        return res

    def __mul__(vec3 self, other):
        cdef vec3_f res
        cdef float res2
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec3_f&>self.cvec * (<float>other)
            return vec3(res[0], res[1], res[2])
        elif otype == vec3:
            res2 = <vec3_f&>self.cvec * (<vec3_f&>(<vec3>other).cvec)
            return res2
        else:
            raise TypeError("unsupported operand type(s) for *: \'{}\' and \'{}\'".format(vec3, otype))

    def __truediv__(self, other not None):
        cdef vec3_f res
        cdef type otype = type(other)
        if type(self) is not vec3 and otype is vec3:
            raise TypeError('vec3 in the right not supported')
        if otype in [float, int]:
            if other == 0:
                raise ZeroDivisionError("can't divide by 0")
            else:
                res = (<vec3_f&>(<vec3>self).cvec) / (<const float>other)
                return vec3(res[0], res[1], res[2])
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(vec3, otype))

    def __xor__(vec3 self, other not None):
        """ Return self^value. """
        cdef vec3_f res
        cdef type otype = type(other)
        if otype is vec3:
            res = (<vec3_f&>(<vec3>self).cvec) ^ (<vec3_f&>(<vec3>other).cvec)
            return vec3(res[0], res[1], res[2])
        else:
            raise TypeError("unsupported operand type(s) for ^: \'{}\' and \'{}\'".format(vec3, otype))

    def __mod__(vec3 self, other not None):
        """ Return self%value. """
        cdef vec3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec3_f&>self.cvec % (<float>other)
        elif otype == vec3:
            res = <vec3_f&>self.cvec % (<vec3_f&>(<vec3>other).cvec)
        else:
            raise TypeError("unsupported operand type(s) for %: \'{}\' and \'{}\'".format(vec3, otype))
        return vec3(res[0], res[1], res[2])

    def __neg__(self):
        cdef vec3 res = vec3()
        res.cvec = -(<vec3_f>self.cvec)
        return res

    def __sub__(self, other not None):
        """ Return self-value. """
        cdef vec3_f res
        cdef type otype = type(other)
        if otype is vec3:
            res = (<vec3_f&>(<vec3>self).cvec) - (<vec3_f&>(<vec3>other).cvec)
            return vec3(res[0], res[1], res[2])
        else:
            raise TypeError("unsupported operand type(s) for -: \'{}\' and \'{}\'".format(vec3, otype))

    def __add__(self, other not None):
        """ Return self+value. """
        cdef vec3_f res
        cdef type otype = type(other)
        if otype is vec3:
            res = (<vec3_f&>(<vec3>self).cvec) + (<vec3_f&>(<vec3>other).cvec)
            return vec3(res[0], res[1], res[2])
        else:
            raise TypeError("unsupported operand type(s) for +: \'{}\' and \'{}\'".format(vec3, otype))

    def __richcmp__(vec3 self, vec3 other, int f):
        if f == 0:
            return self.cvec < other.cvec
        elif f == 1:
            return self.cvec <= other.cvec
        elif f == 2:
            return self.cvec == other.cvec
        elif f == 3:
            return self.cvec != other.cvec
        elif f == 4:
            return self.cvec > other.cvec
        elif f == 5:
            return self.cvec >= other.cvec
        else:
            print(f)

    def __len__(vec3 self):
        return self.items

    def __getitem__(self, int index):
        if index > self.items - 1:
            raise IndexError
        return self.cvec[index]

    def __repr__(self):
        return '[{}, {}, {}]'.format(self.cvec.x, self.cvec.y, self.cvec.z)

    def __sizeof__(self):
        return sizeof(vec3)

    property cSize:
        "Size in memory of c native elements"
        def __get__(self):
            return sizeof(self.cvec)

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

    property epsilon:
       "-"
       def __get__(self):
           return self.cvec.epsilon

    property length:
        "-"
        def __get__(self):
            return self.cvec.length()

    def normalized(vec3 self):
        '''Return a normalized copy of this vector'''
        return vec3.from_cvec(self.cvec.normalize())

    def normalize(self):
        '''Normalize this vector'''
        self.cvec.normalize(self.cvec)

    def ortho(self):
        '''Return a vector that's perpendicular to this'''
        return vec3.from_cvec(self.cvec.ortho())

    def reflect(vec3 self, vec3 other):
        return vec3.from_cvec(self.cvec.reflect(other.cvec))

    def refract(vec3 self, vec3 other, float eta):
        return vec3.from_cvec(self.cvec.refract(other.cvec, eta))

    def max(self):
        '''Return component with maximum value'''
        return self.cvec.max()

    def maxIndex(self):
        '''Return index with maximum value'''
        return self.cvec.maxIndex()

    def maxAbs(self):
        '''Return component with maximum absolute value'''
        return self.cvec.maxAbs()

    def maxAbsIndex(self):
        '''Return index with maximum absolute value'''
        return self.cvec.maxAbsIndex()

    def min(self):
        '''Return component with minimum value'''
        return self.cvec.min()

    def minIndex(self):
        '''Return index with minimum value'''
        return self.cvec.minIndex()

    def minAbs(self):
        '''Return component with minimum absolute value'''
        return self.cvec.minAbs()

    def minAbsIndex(self):
        '''Return index with minimum absolute value'''
        return self.cvec.minAbsIndex()

    def set_polar(self, const float r, const float theta, const float phi):
        self.cvec.set_polar(r, theta, phi)

    def get_polar(self):
        '''Get r, theta, phi tuple'''
        cdef float r_ = 0, theta_ = 0, phi_ = 0
        self.cvec.get_polar(r_, theta_, phi_)
        return r_, theta_, phi_
