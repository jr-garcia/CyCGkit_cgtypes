cimport cvec3 as v3
cimport cvec4 as v4


cdef class vec4:
    def __cinit__(self, *args):
        cdef double x, y, z, w
        cdef list argsl
        self.items = 4
        if args.__len__() == 0:
            self.cvec = vec4_f(0, 0, 0, 0)
            return

        if getattr(args[0], '__getitem__', None):
            if 'numpy.ndarray' in str(type(args[0])) and args[0].ndim > 1:
                raise TypeError('for vectors, Numpy arrays should be 1-D')
            argsl = list(args[0])
        else:
            argsl = list(args)

        if len(argsl) == self.items:
            x = argsl[0]
            y = argsl[1]
            z = argsl[2]
            w = argsl[3]
        elif len(argsl) == self.items -1:
            x = argsl[0]
            y = argsl[1]
            z = argsl[2]
            w = 0.0
        elif len(argsl) == self.items -2:
            x = argsl[0]
            y = argsl[1]
            z = 0.0
            w = 0.0
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

    cdef vec4_f mat4Mul(vec4 self, mat4_f M):
        cdef vec4_f r1, r2, r3, r4, res
        res = self.cvec
        r1 = M.getRow(0)
        r2 = M.getRow(1)
        r3 = M.getRow(2)
        r4 = M.getRow(3)
        return vec4_f(res.x * r1.x + res.y * r2.x + res.z * r3.x + res.w * r4.x,
                      res.x * r1.y + res.y * r2.y + res.z * r3.y + res.w * r4.y,
                      res.x * r1.z + res.y * r2.z + res.z * r3.z + res.w * r4.z,
                      res.x * r1.w + res.y * r2.w + res.z * r3.w + res.w * r4.w)

    def __mul__(self, other):
        cdef vec4_f res
        cdef double res2
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec4_f&>(<vec4>self).cvec * (<double>other)
            return vec4.from_cvec(res)
        elif type(self) in [float, int]:
            res = (<vec4_f&>(<vec4>other).cvec) * (<double>self)
            return vec4.from_cvec(res)
        elif otype == vec4:
            res2 = (<vec4_f&>(<vec4>self).cvec) * (<vec4_f&>(<vec4>other).cvec)
            return res2
        elif otype is mat4:
            return vec4.from_cvec((<vec4>self).mat4Mul((<mat4>other).cvec))
        else:
            raise TypeError("unsupported operand type(s) for *: \'{}\' and \'{}\'".format(vec4, otype))

    def __truediv__(self, other not None):
        cdef type otype = type(other)
        if type(self) is not vec4 and otype is vec4:
            raise TypeError('vec4 in the right not supported')
        if otype in [float, int]:
            if other == 0:
                raise ZeroDivisionError("can't divide by 0")
            else:
                return vec4.from_cvec((<vec4_f&>(<vec4>self).cvec) / (<const double>other))
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(vec4, otype))

    def __div__(self, other not None):
        return self.__truediv__(other)

    def __mod__(vec4 self, other not None):
        """ Return self%value. """
        cdef vec4_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <vec4_f&>self.cvec % (<double>other)
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

    def __getitem__(self, object index):
        cdef type otype = type(index)
        if otype is int:
            if index > self.items - 1:
                raise IndexError(index)
            else:
                return self.cvec[index]
        elif otype is slice:
            return [self.cvec.x, self.cvec.y, self.cvec.z, self.cvec.w][index]
        else:
            raise TypeError('an integer is required')

    def __setitem__(vec4 self, object key, double value):
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
                self.cvec.x = value
            elif r == 1:
                self.cvec.y = value
            elif r == 2:
                self.cvec.z = value
            elif r == 3:
                self.cvec.w = value
            else:
                raise IndexError(r)

    def __repr__(self):
        cdef double xf = round(self.cvec.x, 3)
        cdef double yf = round(self.cvec.y, 3)
        cdef double zf = round(self.cvec.z, 3)
        cdef double wf = round(self.cvec.w, 3)
        cdef object x, y, z, w
        x = int(xf) if int(xf) == round(xf, 3) else round(xf, 3)
        y = int(yf) if int(yf) == round(yf, 3) else round(yf, 3)
        z = int(zf) if int(zf) == round(zf, 3) else round(zf, 3)
        w = int(wf) if int(wf) == round(wf, 3) else round(wf, 3)
        return '[{}, {}, {}, {}]'.format(x, y, z, w)

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

    def normalize(vec4 self):
        '''Normalize this vector'''
        if self.length <= self.epsilon:
            raise ZeroDivisionError("divide by zero");
        self.cvec.normalize(self.cvec)
        return self

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

    def __hash__(self):
        return hash(repr(self))