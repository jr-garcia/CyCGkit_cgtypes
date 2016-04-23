from cpython cimport Py_buffer

cdef _supported_ = ['list with 3 numbers',
                         '3 lists with 3 numbers each',
                         '1 vec3',
                         '3 vec3',
                         'mat3',
                         '1 number',
                         '9 numbers',
                         '2-D numpy array',
                         '1.0 for identity',
                         'empty args']


cdef class mat3:
    def __cinit__(self, *args):
        cdef short argLen = len(args)
        cdef type otype = type(args[0]) if argLen > 0 else None
        self.items = 9
        self.ncols = 3
        self.nrows = 3
        print('entry:',otype)
        if argLen == 0:
            # no arguments
            self.cvec = mat3_f()
        elif otype is mat3:
            # copy from mat3
            self.cvec = (<mat3>args[0]).cvec
        elif str(otype) == "<class 'numpy.ndarray'>":
            # from numpy array
            if args[0].ndim == 2:
                self.cvec = mat3.from_3iterable_of3([args[0][0], args[0][1], args[0][2]])
            else:
                raise TypeError('for matrices, Numpy arrays should be 2-D')
        elif otype is vec3:
            # from vec3
            if argLen == 1:
                # 1 vec
                self.cvec = mat3_f()
                for r in range(3):
                    self.cvec.setRow(r, (<vec3>args[0]).cvec)
            elif argLen == 3:
                # 3 vecs
                self.cvec = mat3_f()
                for r in range(3):
                    self.cvec.setRow(r, (<vec3>args[r]).cvec)
            else:
                raise TypeError('Wrong number of arguments. Expected {} got {}'.format(self.nrows, len(args)))
        elif argLen == self.items:
            # from 9 explicit doubles or ints
            self.cvec = mat3.from_9double(args)
        elif argLen == self.nrows:
            # from 3 explicit elements
            if getattr(args[0], '__getitem__', None) and len(args[0]) == 3:
                # of 3
                self.cvec = mat3.from_3iterable_of3(args)
            else:
                # of 1
                self.cvec = mat3.from_1iterable_of3(args)
        elif argLen == 1 and type(args[0]) in [int, float]:
            # from single double or int
            if args[0] == 1.0:
                # as identity if arg == 1.0
                self.cvec = mat3_f().setIdentity()
            else:
                # 1 repeated double or int
                self.cvec = mat3_f(<double>args[0])
        elif argLen == 1 and otype is list:
            # from list with unknown stuff inside
            print('list')
            self.cvec = mat3(*args[0]).cvec
        else:
            raise TypeError('Wrong number/type of arguments. Expected one of the following:\n{}\ngot {} {}'.format(
                '\n'.join(['- ' + str(s) for s in _supported_]), argLen, otype))

    @staticmethod
    cdef mat3_f from_1iterable_of3(object it3):
        cdef mat3_f tcvec = mat3_f()
        for r in range(3):
            tcvec.setRow(r, vec3_f(it3[0], it3[1], it3[2]))
        return tcvec

    @staticmethod
    cdef mat3_f from_3iterable_of3(object it3):
        cdef mat3_f tcvec = mat3_f()
        for r in range(3):
            tcvec.setRow(r, vec3_f(it3[r][0], it3[r][1], it3[r][2]))
        return tcvec

    @staticmethod
    cdef mat3_f from_9double(object it9):
        cdef double a, b, c, d, e, f, g, h, i
        a, b, c, d, e, f, g, h, i = it9
        cdef mat3_f tcvec = mat3_f(a, b, c, d, e, f, g, h, i)
        return tcvec

    @staticmethod
    cdef mat3 from_cvec(mat3_f cvec):
        cdef mat3 res = mat3()
        res.cvec = cvec
        return res

    def __mul__(mat3 self, other):
        cdef mat3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cvec * (<double>other)
            return mat3.from_cvec(res)
        elif otype == mat3:
            res = <mat3_f&>self.cvec * (<mat3_f&>(<mat3>other).cvec)
            return mat3.from_cvec(res)
        elif otype == vec3:
            return vec3.from_cvec(<mat3_f&>self.cvec * (<vec3_f&>(<vec3>other).cvec))
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
                res = (<mat3_f&>(<mat3>self).cvec) / (<const double>other)
                return mat3.from_cvec(res)
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(mat3, otype))

    def __mod__(mat3 self, other not None):
        """ Return self%value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cvec % (<double>other)
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

        raise TypeError('operator \'{}\' not defined for {}'.format(op, mat3))

    def tolist(self, rowMajor=False):
        cdef list tl = [None, None, None]
        cdef vec3_f r0, r1, r2
        if not rowMajor:
            r0 = self.cvec.getRow(0)
            r1 = self.cvec.getRow(1)
            r2 = self.cvec.getRow(2)
        else:
            r0 = self.cvec.getColumn(0)
            r1 = self.cvec.getColumn(1)
            r2 = self.cvec.getColumn(2)

        tl[0] = [r0.x, r0.y, r0.z]
        tl[1] = [r1.x, r1.y, r1.z]
        tl[2] = [r2.x, r2.y, r2.z]
        return tl

    def toList(self, rowMajor=False):
        return self.tolist(rowMajor)

    def __len__(mat3 self):
        return self.items

    def __getitem__(self, object index):
        cdef type otype = type(index)
        if otype is int:
            if index > self.nrows - 1:
                raise IndexError
            else:
                return vec3.from_cvec(vec3_f(self.cvec.getRow(<int>index)))
        elif otype is slice:
            return self.tolist()[index]
        elif type(index) == tuple:
            return vec3_f(self.cvec.getRow(<int>index[0]))[<int>index[1]]
        else:
            raise TypeError('an integer is required')

    cdef checkViews(self):
        if self.view_count > 0:
            raise ValueError("can't modify it while being viewed")

    def __setitem__(mat3 self, object key, object value):
        cdef type otype = type(key)
        self.checkViews()
        cdef list rows = []
        cdef int r
        cdef vec3_f nval

        if otype is int:
            if key > self.nrows - 1:
                raise IndexError
            else:
                rows.append(key)
        elif otype is slice:
            for r in range(key.start, key.stop, key.step if key.step is not None else 1):
                rows.append(r)
        elif otype == tuple:
            if type(value) is vec3:
                for r in key:
                    rows.append(r)
            elif type(value) in [float, int]:
                if len(key) > 2:
                    raise ValueError('index tuple must be a 2-tuple')
                self.cvec.getRow(key[0], nval)
                r = key[1]
                if r == 0:
                    nval.x = value
                elif r == 1:
                    nval.y = value
                elif r == 2:
                    nval.z = value
                else:
                    raise IndexError(r)

                self.cvec.setRow(key[0], nval)
                return
        else:
            raise TypeError('an integer is required')
        if type(value) is not vec3:
            raise TypeError('a vec3 is required')
        for r in rows:
            self.cvec.setRow(r, (<vec3>value).cvec)

    def __repr__(self):
        return '[' + ',\n'.join(str(l) for l in self.tolist()) + ']'

    def __sizeof__(self):
        return sizeof(mat3)

    property cSize:
        "Size in memory of c native elements"
        def __get__(self):
            return sizeof(self.cvec)

    def ortho(self):
        '''Return this matrix's ortho'''
        return mat3.from_cvec(self.cvec.ortho())

    def __getbuffer__(self, Py_buffer *buffer, int flags):
        cdef Py_ssize_t itemsize = sizeof(double)

        self.shape[0] = self.nrows
        self.shape[1] = self.ncols

        # Stride 1 is the distance, in bytes, between two items in a row;
        # this is the distance between two adjacent items in the vector.
        # Stride 0 is the distance between the first elements of adjacent rows.
        cdef long a = <long>&((<vec3_f>self.cvec.getRow(0))[1])
        cdef long b = <long>&((<vec3_f>self.cvec.getRow(0))[0])
        self.strides[1] = <Py_ssize_t>(a - b)
        self.strides[0] = self.ncols * self.strides[1]

        buffer.buf = <double*>(<vec3_f*>&self.cvec)
        buffer.format = 'd'                     # double
        buffer.internal = NULL                  # see References
        buffer.itemsize = itemsize
        buffer.len = sizeof(self.items) * itemsize   # product(shape) * itemsize
        buffer.ndim = 2
        buffer.obj = self
        buffer.readonly = 0
        buffer.shape = self.shape
        buffer.strides = self.strides
        buffer.suboffsets = NULL                # for pointer arrays only
        self.view_count += 1
        #todo: check flags
        '''
        Strictly speaking, if the flags contain PyBUF_ND, PyBUF_SIMPLE, or PyBUF_F_CONTIGUOUS, __getbuffer__ must
        raise a BufferError. These macros can be cimport‘d from cpython.buffer.
        '''

    def __releasebuffer__(self, Py_buffer *buffer):
        self.view_count -= 1

    ########################  Advanced methods  ########################

    def at(mat3 self, short i, short j):
        return self.cvec.at(i, j)

    # set_ and get_ methods
    def setIdentity(mat3 self):
        self.checkViews()
        self.cvec.setIdentity()

    def setRow(mat3 self, int row, vec3 val):
        self.checkViews()
        self.cvec.setRow(row, val.cvec)

    def setRow(mat3 self, short row, const double a, const double b, const double c):
        self.checkViews()
        self.cvec.setRow(row, a, b, c)

    def setColumn(mat3 self, int col, vec3 val):
        self.checkViews()
        self.cvec.setColumn(col, val.cvec)

    def setColumn(mat3 self, short col, const double a, const double b, const double c):
        self.checkViews()
        self.cvec.setColumn(col, a, b, c)

    def setDiag(mat3 self, vec3 val):
        self.checkViews()
        self.cvec.setDiag(val.cvec)

    def setDiag(mat3 self, const double a, const double b, const double c):
        self.checkViews()
        self.cvec.setDiag(a, b, c)

    def getRow(mat3 self, short i, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cvec.getRow(i, dest.cvec)
        else:
            a = b = c = 0
            self.cvec.getRow(i, a, b, c)
            dest = vec3(a, b, c)
            return a, b, c

    def getColumn(mat3 self, short i, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cvec.getColumn(i, dest.cvec)
        else:
            a = b = c = 0
            self.cvec.getColumn(i, a, b, c)
            dest = vec3(a, b, c)
            return a, b, c

    def getDiag(mat3 self, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cvec.getDiag(dest.cvec)
        else:
            a = b = c = 0
            self.cvec.getDiag(a, b, c)
            dest = vec3(a, b, c)
            return a, b, c

    def setRotation(mat3 self, double angle, vec3 axis):
        self.checkViews()
        self.cvec.setRotation(angle, axis.cvec)

        # mat3[T]& setRotationZXY(T x, T y, T z)
        # mat3[T]& setRotationYXZ(T x, T y, T z)
        # mat3[T]& setRotationXYZ(T x, T y, T z)
        # mat3[T]& setRotationXZY(T x, T y, T z)
        # mat3[T]& setRotationYZX(T x, T y, T z)
        # mat3[T]& setRotationZYX(T x, T y, T z)
        # void getRotationZXY(T& x, T& y, T& z) const
        # void getRotationYXZ(T& x, T& y, T& z) const
        # void getRotationXYZ(T& x, T& y, T& z) const
        # void getRotationXZY(T& x, T& y, T& z) const
        # void getRotationYZX(T& x, T& y, T& z) const
        # void getRotationZYX(T& x, T& y, T& z) const
        #
        # mat3[T]& fromToRotation(const v3.vec3[T]& from_, const v3.vec3[T]& to)

    def setScaling(mat3 self, vec3 scale):
        self.checkViews()
        self.cvec.setScaling(scale.cvec)