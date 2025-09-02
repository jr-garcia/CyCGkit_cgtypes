# cython: c_string_type=bytes
# cython: c_string_encoding=utf8
# cython: language_level=3
# distutils: language=c++

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

from cython cimport fused_type

cdef fused _numeric_type:
    int
    long
    short
    float
    double


cdef class mat3:
    def __cinit__(self, *args):
        cdef short argLen = len(args)
        cdef type otype = type(args[0]) if argLen > 0 else None
        self.items = 9
        self.ncols = 3
        self.nrows = 3
        self.isTransposed = False

        if argLen == 0:
            # no arguments
            self.cmat = mat3_f()
        elif otype is mat3:
            # copy from mat3
            self.cmat = (<mat3>args[0]).cmat
        elif 'numpy.ndarray' in str(otype):
            # from numpy array
            if args[0].ndim == 2:
                self.cmat = mat3.from_3iterable_of3([args[0][0], args[0][1], args[0][2]])
            else:
                raise TypeError('for matrices, Numpy arrays should be 2-D')
        elif otype is vec3:
            # from vec3
            if argLen == 1:
                # 1 vec
                self.cmat = mat3_f()
                for r in range(3):
                    self.cmat.setColumn(r, (<vec3>args[0]).cvec)
            elif argLen == 3:
                # 3 vecs
                self.cmat = mat3_f()
                for r in range(3):
                    self.cmat.setColumn(r, (<vec3>args[r]).cvec)
            else:
                raise TypeError('Wrong number of arguments. Expected {} got {}'.format(self.nrows, len(args)))
        elif argLen == self.items:
            # from 9 explicit doubles or ints
            self.cmat = mat3.from_9double(args)
        elif argLen == self.nrows:
            # from 3 explicit elements
            if getattr(args[0], '__getitem__', None) and len(args[0]) == 3:
                # of 3
                self.cmat = mat3.from_3iterable_of3(args)
            else:
                # of 1
                self.cmat = mat3.from_1iterable_of3(args)
        elif argLen == 1 and type(args[0]) in [int, float]:
            # from single double or int
            if args[0] == 1.0:
                # as identity if arg == 1.0
                self.cmat = mat3_f().setIdentity()
            else:
                # 1 repeated double or int
                self.cmat = mat3_f(<double>args[0])
        elif argLen == 1 and otype is list:
            # from list with unknown stuff inside
            self.cmat = mat3(*args[0]).cmat
        else:
            raise TypeError('Wrong number/type of arguments. Expected one of the following:\n{}\ngot {} {}'.format(
                '\n'.join(['- ' + str(s) for s in _supported_]), argLen, otype))

    @staticmethod
    cdef mat3_f from_1iterable_of3(object it3):
        cdef mat3_f tcmat = mat3_f()
        for r in range(3):
            tcmat.setColumn(r, vec3_f(it3[0], it3[1], it3[2]))
        return tcmat

    @staticmethod
    cdef mat3_f from_3iterable_of3(object it3):
        cdef mat3_f tcmat = mat3_f()
        for r in range(3):
            tcmat.setColumn(r, vec3_f(it3[r][0], it3[r][1], it3[r][2]))
        return tcmat

    @staticmethod
    cdef mat3_f from_9double(object it9):
        cdef double a, b, c, d, e, f, g, h, i
        a, b, c, d, e, f, g, h, i = it9
        cdef mat3_f tcmat = mat3_f(a, b, c, d, e, f, g, h, i)
        return tcmat

    @staticmethod
    cdef mat3 from_cmat(mat3_f cmat):
        cdef mat3 res = mat3()
        res.cmat = cmat
        return res

    def __mul__(mat3 self, other):
        cdef mat3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cmat * (<double>other)
            return mat3.from_cmat(res)
        elif otype == mat3:
            res = <mat3_f&>self.cmat * (<mat3_f&>(<mat3>other).cmat)
            return mat3.from_cmat(res)
        elif otype == vec3:
            return vec3.from_cvec(<mat3_f&>self.cmat * (<vec3_f&>(<vec3>other).cvec))
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
                res = (<mat3_f&>(<mat3>self).cmat) / (<const double>other)
                return mat3.from_cmat(res)
        else:
            raise TypeError("unsupported operand type(s) for /: \'{}\' and \'{}\'".format(mat3, otype))

    def __div__(self, other not None):
        return self.__truediv__(other)

    def __mod__(mat3 self, other not None):
        """ Return self%value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype in [float, int]:
            res = <mat3_f&>self.cmat % (<double>other)
        elif otype == mat3:
            res = <mat3_f&>self.cmat % (<mat3_f&>(<mat3>other).cmat)
        else:
            raise TypeError("unsupported operand type(s) for %: \'{}\' and \'{}\'".format(mat3, otype))
        return mat3.from_cmat(res)

    def __neg__(self):
        cdef mat3 res = mat3()
        res.cmat = -(<mat3_f>self.cmat)
        return res

    def __sub__(self, other not None):
        """ Return self-value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype is mat3:
            res = (<mat3_f&>(<mat3>self).cmat) - (<mat3_f&>(<mat3>other).cmat)
            return mat3.from_cmat(res)
        else:
            raise TypeError("unsupported operand type(s) for -: \'{}\' and \'{}\'".format(mat3, otype))

    def __add__(self, other not None):
        """ Return self+value. """
        cdef mat3_f res
        cdef type otype = type(other)
        if otype is mat3:
            res = (<mat3_f&>(<mat3>self).cmat) + (<mat3_f&>(<mat3>other).cmat)
            return mat3.from_cmat(res)
        else:
            raise TypeError("unsupported operand type(s) for +: \'{}\' and \'{}\'".format(mat3, otype))

    def __richcmp__(mat3 self, mat3 other, int f):
        cdef str op
        if f == 0:
            op = '<'
        elif f == 1:
            op = '<='
        if f == 2:
            return self.cmat == other.cmat
        elif f == 3:
            return self.cmat != other.cmat
        elif f == 4:
            op = '>'
        elif f == 5:
            op = '>='

        raise TypeError('operator \'{}\' not defined for {}'.format(op, mat3))

    def tolist(self, rowMajor=False):
        cdef list tl
        cdef vec3_f r0, r1, r2
        if rowMajor:
            r0 = self.cmat.getRow(0)
            r1 = self.cmat.getRow(1)
            r2 = self.cmat.getRow(2)
        else:
            r0 = self.cmat.getColumn(0)
            r1 = self.cmat.getColumn(1)
            r2 = self.cmat.getColumn(2)

        tl = [r0.x, r0.y, r0.z, r1.x, r1.y, r1.z, r2.x, r2.y, r2.z]
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
                return vec3.from_cvec(vec3_f(self.cmat.getColumn(<int>index)))
        elif otype is slice:
            raise TypeError('index must be integer or 2-tuple')
        elif otype is tuple:
            return self.cmat.getRow(<int>index[0])[<int>index[1]]
        else:
            raise TypeError('index must be integer or 2-tuple')

    cdef checkViews(self):
        if self.view_count > 0:
            raise ValueError("can't modify it while being viewed")

    def __setitem__(mat3 self, object key, object value):
        self.checkViews()
        cdef type otype = type(key)
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
                self.cmat.getColumn(key[0], nval)
                r = key[1]
                if r == 0:
                    nval.x = value
                elif r == 1:
                    nval.y = value
                elif r == 2:
                    nval.z = value
                else:
                    raise IndexError(r)
                self.cmat.setColumn(key[0], nval)
                return
        else:
            raise TypeError('an integer is required')

        if type(value) is not vec3:
            raise TypeError('a vec3 is required')
        for r in rows:
            self.cmat.setColumn(r, (<vec3>value).cvec)

    def __repr__(self):
        cdef vec3 v = vec3()
        cdef list res = [None, None, None]
        for x in range(3):
            _ = self.getRow(x, v)
            res[x] = v.__repr__() + '\n'
        return ''.join(s for s in res)

    def __sizeof__(self):
        return sizeof(mat3)

    property cSize:
        "Size in memory of c native elements"
        def __get__(self):
            return sizeof(self.cmat)

    def ortho(self, inplace=False):
        '''
        Return this matrix's ortho if inplace=False.
        or Apply ortho to this matrix in place
        '''
        if inplace:
            self.checkViews()
            self.cmat.ortho(self.cmat)
            return self
        else:
            return mat3.from_cmat(self.cmat.ortho())

    ########################  Advanced methods  ########################
    def __getbuffer__(self, Py_buffer *buffer, int flags):
        self.view_count += 1
        if not self.isTransposed:
            self.cmat.transpose(self.cmat)
            self.isTransposed = True
        cdef Py_ssize_t itemsize = sizeof(double)

        self.shape[0] = self.nrows
        self.shape[1] = self.ncols

        # Stride 1 is the distance, in bytes, between two items in a row;
        # this is the distance between two adjacent items in the vector.
        # Stride 0 is the distance between the first elements of adjacent rows.
        self.strides[1] =  itemsize
        self.strides[0] = self.ncols * self.strides[1]

        buffer.buf = <double*>(<mat3_f*>&self.cmat)
        buffer.format = 'd'                     # double
        buffer.internal = NULL                  # see References
        buffer.itemsize = itemsize
        buffer.len = self.items * itemsize   # product(shape) * itemsize
        buffer.ndim = 2
        buffer.obj = self
        buffer.readonly = 0
        buffer.shape = self.shape
        buffer.strides = self.strides
        buffer.suboffsets = NULL                # for pointer arrays only
        #todo: check flags
        '''
        Strictly speaking, if the flags contain PyBUF_ND, PyBUF_SIMPLE, or PyBUF_F_CONTIGUOUS, __getbuffer__ must
        raise a BufferError. These macros can be cimport‘d from cpython.buffer.
        '''

    def __releasebuffer__(self, Py_buffer *buffer):
        self.view_count -= 1
        if self.view_count == 0:
            self.cmat.transpose(self.cmat)
            self.isTransposed = False

    def at(mat3 self, short i, short j):
        return self.cmat.at(i, j)

    @staticmethod
    def identity():
        cdef mat3 res = mat3()
        res.cmat.setIdentity()
        return res

    # set_ and get_ methods
    def setIdentity(mat3 self):
        self.checkViews()
        self.cmat.setIdentity()
        return self

    def setRow(mat3 self, short row, *args):
        cdef double a, b, c, d
        self.checkViews()
        if len(args) == 3 and all(type(arg) in [float, int] for arg in args):
            a, b, c = args
            self.cmat.setRow(row, a, b, c)
            return self
        elif len(args) == 1 and isinstance(args[0], vec3):
            self.cmat.setRow(row, (<vec3>args[0]).cvec)
            return self
        else:
            raise TypeError("setRow() takes either a vec3 or 3 floats.")

    def setColumn(mat3 self, short col, *args):
        cdef double a, b, c
        self.checkViews()
        if len(args) == 3 and all((isinstance(arg, int) or isinstance(arg, float)) for arg in args):
            a, b, c = args
            self.cmat.setColumn(col, a, b, c)
            return self
        elif len(args) == 1 and isinstance(args[0], vec3):
            self.cmat.setColumn(col, (<vec3>args[0]).cvec)
            return self
        else:
            raise TypeError("setColumn() takes either a vec3 or 3 floats.")

    def setDiag(mat3 self, *args):
        cdef double a, b, c
        self.checkViews()
        if len(args) == 3 and all((isinstance(arg, int) or isinstance(arg, float)) for arg in args):
            a, b, c = args
            self.cmat.setDiag(a, b, c)
            return self
        elif len(args) == 1 and isinstance(args[0], vec3):
            self.cmat.setDiag((<vec3>args[0]).cvec)
            return self
        else:
            raise TypeError("Invalid arguments")

    def getRow(mat3 self, short i, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cmat.getRow(i, dest.cvec)
        else:
            a = b = c = 0
            self.cmat.getRow(i, a, b, c)
            return a, b, c

    def getColumn(mat3 self, short i, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cmat.getColumn(i, dest.cvec)
        else:
            a = b = c = 0
            self.cmat.getColumn(i, a, b, c)
            return a, b, c

    def getDiag(mat3 self, vec3 dest=None):
        cdef double a, b, c
        if dest is not None:
            self.cmat.getDiag(dest.cvec)
        else:
            a = b = c = 0
            self.cmat.getDiag(a, b, c)
            return a, b, c

    def setRotation(mat3 self, double angle, vec3 axis):
        self.checkViews()
        self.cmat.setRotation(angle, axis.cvec)
        return self

    def setRotationZXY(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationZXY(x, y, z)
        return self

    def setRotationYXZ(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationYXZ(x, y, z)
        return self

    def setRotationXYZ(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationXYZ(x, y, z)
        return self

    def setRotationXZY(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationXZY(x, y, z)
        return self

    def setRotationYZX(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationYZX(x, y, z)
        return self

    def setRotationZYX(mat3 self, double x, double y, double z):
        self.checkViews()
        self.cmat.setRotationZYX(x, y, z)
        return self

    cdef tuple getRotation(mat3 self, bint a=False, bint b=False, bint c=False, bint d=False, bint e=False, bint f=False):
        cdef double x=0, y=0, z=0
        if a:
            self.cmat.getRotationZXY(x, y, z)
        elif b:
            self.cmat.getRotationYXZ(x, y, z)
        elif c:
            self.cmat.getRotationXYZ(x, y, z)
        elif d:
            self.cmat.getRotationXZY(x, y, z)
        elif e:
            self.cmat.getRotationYZX(x, y, z)
        elif f:
            self.cmat.getRotationZYX(x, y, z)
        else:
            raise IndexError('wrong getRotation index!')
        return x, y, z

    def getRotationZXY(self):
        return self.getRotation(a=True)

    def getRotationYXZ(self):
        return self.getRotation(a=False, b=True)

    def getRotationXYZ(self):
        return self.getRotation(a=False, b=False, c=True)

    def getRotationXZY(self):
        return self.getRotation(a=False, b=False, c=False, d=True)

    def getRotationYZX(self):
        return self.getRotation(a=False, b=False, c=False, d=False, e=True)

    def getRotationZYX(self):
        return self.getRotation(a=False, b=False, c=False, d=False, e=False, f=True)

    def fromToRotation(mat3 self, vec3 from_, vec3 to):
        self.checkViews()
        self.cmat.fromToRotation(from_.cvec, to.cvec)
        return self

    @staticmethod
    def scaling(vec3 scale):
        '''Returns a matrix set to "scale"'''
        cdef mat3 res = mat3()
        res.cmat.setScaling(scale.cvec)
        return res

    def setScaling(mat3 self, vec3 scale):
      '''Set this matrix to "scale"'''
      self.checkViews()
      self.cmat.setScaling(scale.cvec)
      return self

    def determinant(mat3 self):
        return self.cmat.determinant()

    def inverted(mat3 self):
        '''Returns a copy of this matrix inverse'''
        return mat3.from_cmat(self.cmat.inverse())

    def inverse(mat3 self):
        '''Invert this matrix in place'''
        self.checkViews()
        self.cmat.inverse(self.cmat)
        return self

    def transposed(mat3 self):
        '''Returns a copy of this matrix transpose'''
        return mat3.from_cmat(self.cmat.transpose())

    def transpose(mat3 self):
        '''Transpose this matrix in place'''
        self.checkViews()
        self.cmat.transpose(self.cmat)
        return self

    def scale(mat3 self, vec3 s):
        '''Scale this matrix for "s"'''
        self.checkViews()
        self.cmat.scale(s.cvec)
        return self

    def rotate(mat3 self, double angle, vec3 axis):
        '''Rotate this matrix'''
        self.checkViews()
        self.cmat.rotate(angle, axis.cvec)
        return self

    def decompose(mat3 self):
        '''Decompose this matrix into a mat3 for rotation and a
        vec3 for scale'''
        cdef mat3_f rot
        cdef vec3_f scale
        self.cmat.decompose(rot, scale)
        return mat3.from_cmat(rot), vec3.from_cvec(scale)

    ########################  euler <-> rot cg compat  ########################

    @staticmethod
    def fromEulerZXY(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationZXY(x, y, z)
        return res

    @staticmethod
    def fromEulerXYZ(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationXYZ(x, y, z)
        return res

    @staticmethod   
    def fromEulerXYZ(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationXYZ(x, y, z)
        return res

    @staticmethod
    def fromEulerXZY(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationXZY(x, y, z)
        return res

    @staticmethod
    def fromEulerYZX(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationYZX(x, y, z)
        return res
        
    @staticmethod
    def fromEulerZYX(double x, double y, double z):
        cdef mat3 res = mat3()
        res.setRotationZYX(x, y, z)
        return res

    def toEulerZXY(self):
        return self.getRotation(a=True)

    def toEulerYXZ(self):
        return self.getRotation(a=False, b=True)

    def toEulerXYZ(self):
        return self.getRotation(a=False, b=False, c=True)

    def toEulerXZY(self):
        return self.getRotation(a=False, b=False, c=False, d=True)

    def toEulerYZX(self):
        return self.getRotation(a=False, b=False, c=False, d=False, e=True)

    def toEulerZYX(self):
        return self.getRotation(a=False, b=False, c=False, d=False, e=False, f=True)

    def __hash__(self):
        return hash(repr(self))