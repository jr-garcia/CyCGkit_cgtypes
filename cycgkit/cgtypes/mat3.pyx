cimport cmat3 as m3

from cpython cimport Py_buffer


cdef class mat3:
    def __cinit__(self, *args):
        cdef float a, b, c, d, e, f, g, h, i
        cdef list argsl
        self.items = 9
        self.ncols = 3
        self.nrows = 3

        if args.__len__() == 0:
            self.cvec = mat3_f(0)
            return

        if getattr(args[0], '__getitem__', None):
            if str(type(args[0])) == "<class 'numpy.ndarray'>" and args[0].ndim > 1:
                raise TypeError('for vectors, Numpy arrays should be 1-D')
            argsl = list(args[0])
        else:
            argsl = list(args)

        if len(argsl) == self.items:
            a, b, c, d, e, f, g, h, i = argsl
        elif len(argsl) == 1 and type(argsl[0]) in [int, float]:
            a, b, c, d, e, f, g, h, i = [argsl] * 9
        else:
            raise TypeError('Wrong number of arguments. Expected {} got {}'.format(self.items, len(argsl)))

        self.cvec = mat3_f(a, b, c, d, e, f, g, h, i)

    @staticmethod
    cdef mat3 from_cvec(mat3_f cvec):
        cdef mat3 res = mat3()
        res.cvec = cvec
        return res

    def __mul__(mat3 self, other):
        cdef mat3_f res
        # cdef float res2
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cvec * (<float>other)
            return mat3.from_cvec(res)
        elif otype == mat3:
            res = <mat3_f&>self.cvec * (<mat3_f&>(<mat3>other).cvec)
            return mat3.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for *: \'{}\' and \'{}\'".format(mat3, otype))

    def __truediv__(self, other not None):
        cdef mat3_f res
        cdef type otype = type(other)
        if type(self) is not mat3 and otype is mat3:
            raise TypeError('mat3 in the right not supported')
        if otype in [float, int]:
            if other == 0:
                raise ZeroDivisionError("can't divide by 0")
            else:
                res = (<mat3_f&>(<mat3>self).cvec) / (<const float>other)
                return mat3.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(mat3, otype))

    def __mod__(mat3 self, other not None):
        """ Return self%value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cvec % (<float>other)
        elif otype == mat3:
            res = <mat3_f&>self.cvec % (<mat3_f&>(<mat3>other).cvec)
        else:
            raise TypeError("unsupported operand type(s) for %: \'{}\' and \'{}\'".format(mat3, otype))
        return mat3.from_cvec(res)

    def __neg__(self):
        cdef mat3 res = mat3()
        res.cvec = -(<mat3_f>self.cvec)
        return res

    def __sub__(self, other not None):
        """ Return self-value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype is mat3:
            res = (<mat3_f&>(<mat3>self).cvec) - (<mat3_f&>(<mat3>other).cvec)
            return mat3.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for -: \'{}\' and \'{}\'".format(mat3, otype))

    def __add__(self, other not None):
        """ Return self+value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype is mat3:
            res = (<mat3_f&>(<mat3>self).cvec) + (<mat3_f&>(<mat3>other).cvec)
            return mat3.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for +: \'{}\' and \'{}\'".format(mat3, otype))

    def __richcmp__(mat3 self, mat3 other, int f):
        # if f == 0:
        #     return self.cvec < other.cvec
        # elif f == 1:
        #     return self.cvec <= other.cvec
        if f == 2:
            return self.cvec == other.cvec
        elif f == 3:
            return self.cvec != other.cvec
        # elif f == 4:
        #     return self.cvec > other.cvec
        # elif f == 5:
        #     return self.cvec >= other.cvec

    def tolist(self):
        # cdef list[float] lst = None
        # self.cvec.toList(<float*>lst, False)
        # return lst
        cdef list tl = []
        cdef vec3_f r0, r1, r2
        r0 = self.cvec.getRow(0)
        r1 = self.cvec.getRow(1)
        r2 = self.cvec.getRow(2)

        tl.append([r0.x, r0.y, r0.z])
        tl.append([r1.x, r1.y, r1.z])
        tl.append([r2.x, r2.y, r2.z])
        return tl

    def __len__(mat3 self):
        return self.items

    def __getitem__(self, object index):
        cdef list lis =self.tolist()
        print('item', index)
        if type(index) == tuple:
            print('cou', len(index))
            return lis[index[0]][index[1]]
        else:
            return lis[index]
        # return self.cvec[index]

    def __repr__(self):
        return str(self.tolist())

    def __sizeof__(self):
        return sizeof(mat3)

    property cSize:
        "Size in memory of c native elements"
        def __get__(self):
            return sizeof(self.cvec)

    # property epsilon:
    #    "-"
    #    def __get__(self):
    #        return vec3_f().epsilon

    def ortho(self):
        '''Return this matrix's ortho'''
        return mat3.from_cvec(self.cvec.ortho())

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        cdef Py_ssize_t itemsize = sizeof(float)

        self.shape[0] = sizeof(self.cvec) / self.ncols
        self.shape[1] = self.ncols

        # Stride 1 is the distance, in bytes, between two items in a row;
        # this is the distance between two adjacent items in the vector.
        # Stride 0 is the distance between the first elements of adjacent rows.
        # self.strides[1] = <Py_ssize_t>(<char*>((<vec3_f>self.cvec.getRow(0))[1])
        #                                - <float*>((<vec3_f>self.cvec.getRow(0))[0]))
        self.strides[1] = itemsize
        self.strides[0] = self.ncols * self.strides[1]

        buffer.buf = <float*>(&(<vec3_f>self.cvec.getRow(0))[0])
        buffer.format = 'f'                     # float
        buffer.internal = NULL                  # see References
        buffer.itemsize = itemsize
        buffer.len = sizeof(self.cvec) * itemsize   # product(shape) * itemsize
        buffer.ndim = 2
        buffer.obj = self
        buffer.readonly = 0
        buffer.shape = self.shape
        buffer.strides = self.strides
        buffer.suboffsets = NULL                # for pointer arrays only

    def __releasebuffer__(self, Py_buffer *buffer):
        pass

