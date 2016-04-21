cimport cvec3 as v3
cimport cvec4 as v4


cdef class vec4:
    def __cinit__(self, *args):
        cdef float x, y, z, w
        cdef list argsl
        self.items = 4
        if args.__len__() == 0:
            self.cvec = vec4_f(0, 0, 0, 0)
            return

        if getattr(args[0], '__getitem__', None):
            if str(type(args[0])) == "<class 'numpy.ndarray'>" and args[0].ndim > 1:
                raise TypeError('for vectors, Numpy arrays should be 1-D')
            argsl = list(args[0])
        else:
            argsl = list(args)

        if len(argsl) == self.items:
            x = argsl[0]
            y = argsl[1]
            z = argsl[2]
            w = argsl[3]
        elif len(argsl) == 1 and type(argsl[0]) in [int, float]:
            x = y = z = w = argsl[0]
        else:
            raise TypeError('Wrong number of arguments. Expected {} got {}'.format(self.items, len(argsl)))

        self.cvec = vec4_f(x, y, z, w)

    @staticmethod
    cdef vec4 from_cvec(vec4_f cvec):
        cdef vec4 res = vec4()
        res.cvec = cvec
        return res

    def __mul__(vec4 self, other):
        cdef vec4_f res
        cdef float res2
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec4_f&>self.cvec * (<float>other)
            return vec4(res[0], res[1], res[2], res[3])
        elif otype == vec4:
            res2 = <vec4_f&>self.cvec * (<vec4_f&>(<vec4>other).cvec)
            return res2
        else:
            raise TypeError("unsupported operand type(s) for *: \'{}\' and \'{}\'".format(vec4, otype))

    def __truediv__(self, other not None):
        cdef vec4_f res
        cdef type otype = type(other)
        if type(self) is not vec4 and otype is vec4:
            raise TypeError('vec4 in the right not supported')
        if otype in [float, int]:
            if other == 0:
                raise ZeroDivisionError("can't divide by 0")
            else:
                res = (<vec4_f&>(<vec4>self).cvec) / (<const float>other)
                return vec4(res[0], res[1], res[2], res[3])
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(vec4, otype))

    # def __xor__(vec4 self, other not None):
    #     """ Return self^value. """
    #     cdef vec4_f res
    #     cdef type otype = type(other)
    #     if otype is vec4:
    #         res = (<vec4_f&>(<vec4>self).cvec) ^ (<vec4_f&>(<vec4>other).cvec)
    #         return vec4(res[0], res[1], res[2], res[3])
    #     else:
    #         raise TypeError("unsupported operand type(s) for ^: \'{}\' and \'{}\'".format(vec4, otype))

    def __mod__(vec4 self, other not None):
        """ Return self%value. """
        cdef vec4_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec4_f&>self.cvec % (<float>other)
        elif otype == vec4:
            res = <vec4_f&>self.cvec % (<vec4_f&>(<vec4>other).cvec)
        else:
            raise TypeError("unsupported operand type(s) for %: \'{}\' and \'{}\'".format(vec4, otype))
        return vec4(res[0], res[1], res[2], res[3])

    def __neg__(self):
        cdef vec4 res = vec4()
        res.cvec = -(<vec4_f>self.cvec)
        return res

    def __sub__(self, other not None):
        """ Return self-value. """
        cdef vec4_f res
        cdef type otype = type(other)
        if otype is vec4:
            res = (<vec4_f&>(<vec4>self).cvec) - (<vec4_f&>(<vec4>other).cvec)
            return vec4(res[0], res[1], res[2], res[3])
        else:
            raise TypeError("unsupported operand type(s) for -: \'{}\' and \'{}\'".format(vec4, otype))

    def __add__(self, other not None):
        """ Return self+value. """
        cdef vec4_f res
        cdef type otype = type(other)
        if otype is vec4:
            res = (<vec4_f&>(<vec4>self).cvec) + (<vec4_f&>(<vec4>other).cvec)
            return vec4(res[0], res[1], res[2], res[3])
        else:
            raise TypeError("unsupported operand type(s) for +: \'{}\' and \'{}\'".format(vec4, otype))

    def __richcmp__(vec4 self, vec4 other, int f):
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

    def __len__(vec4 self):
        return self.items

    def __getitem__(self, int index):
        if index > self.items - 1:
            raise IndexError
        return self.cvec[index]

    def __repr__(self):
        return '[{}, {}, {}, {}]'.format(self.cvec.x, self.cvec.y, self.cvec.z, self.cvec.w)

    def __sizeof__(self):
        return sizeof(vec4)

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

    property w:
        "-"
        def __get__(self):
            return self.cvec.w

        def __set__(self, value):
           self.cvec.w = value

    property epsilon:
       "-"
       def __get__(self):
           return vec3_f().epsilon

    property length:
        "-"
        def __get__(self):
            return self.cvec.length()

    def normalized(vec4 self):
        '''Return a normalized copy of this vector'''
        if self.length <= self.epsilon:
            raise ZeroDivisionError("divide by zero");
        return vec4.from_cvec(self.cvec.normalize())

    def normalize(self):
        '''Normalize this vector'''
        if self.length <= self.epsilon:
            raise ZeroDivisionError("divide by zero");
        self.cvec.normalize(self.cvec)

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