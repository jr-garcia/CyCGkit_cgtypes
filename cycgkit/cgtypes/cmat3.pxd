from cvec3 cimport vec3

ctypedef bint bool

cdef extern from "mat3.h" namespace 'support3d' nogil:
    cdef cppclass mat3[T]:
        # Constructors
        mat3()
        mat3(T v)
        mat3(T a, T b, T c,
             T d, T e, T f,
             T g, T h, T i)
        mat3(const mat3[T]& A)

        #T& at(short i, short j)
        const T& at(short i, short j) const

        # set_ and get_ methods
        mat3[T]& setIdentity()
        mat3[T]& setNull()
        mat3[T]& setRow(short i, const vec3[T]& r)
        mat3[T]& setRow(short i, const T a, const T b, const T c)
        mat3[T]& setColumn(short i, const vec3[T]& c)
        mat3[T]& setColumn(short i, const T a, const T b, const T c)
        mat3[T]& setDiag(const vec3[T]& d)
        mat3[T]& setDiag(T a, T b, T c)
        vec3[T]  getRow(short i) const
        void     getRow(short i, vec3[T]& dest) const
        void     getRow(short i, T& a, T& b, T& c) const
        vec3[T]  getColumn(short i) const
        void     getColumn(short i, vec3[T]& dest) const
        void     getColumn(short i, T& a, T& b, T& c) const
        vec3[T]  getDiag() const
        void     getDiag(vec3[T]& dest) const
        void     getDiag(T& a, T& b, T& c) const

        mat3[T]& setRotation(T angle, const vec3[T]& axis)
        mat3[T]& setScaling(const vec3[T]& s)

        mat3[T]& setRotationZXY(T x, T y, T z)
        mat3[T]& setRotationYXZ(T x, T y, T z)
        mat3[T]& setRotationXYZ(T x, T y, T z)
        mat3[T]& setRotationXZY(T x, T y, T z)
        mat3[T]& setRotationYZX(T x, T y, T z)
        mat3[T]& setRotationZYX(T x, T y, T z)
        void getRotationZXY(T& x, T& y, T& z) const
        void getRotationYXZ(T& x, T& y, T& z) const
        void getRotationXYZ(T& x, T& y, T& z) const
        void getRotationXZY(T& x, T& y, T& z) const
        void getRotationYZX(T& x, T& y, T& z) const
        void getRotationZYX(T& x, T& y, T& z) const

        mat3[T]& fromToRotation(const vec3[T]& from_, const vec3[T]& to)

        # Operators
        #mat3[T]& operator+=(const mat3[T]& A)       # matrix += matrix
        #mat3[T]& operator-=(const mat3[T]& A)       # matrix -= matrix
        #mat3[T]& operator*=(const mat3[T]& A)       # matrix *= matrix
        #mat3[T]& operator*=(const T s)              # matrix *= scalar
        #mat3[T]& operator/=(const T s)              # matrix /= scalar
        #mat3[T]& operator%=(const T r)
        #mat3[T]& operator%=(const mat3[T]& b)

        mat3[T] operator+(const mat3[T]& A) const   # matrix = matrix + matrix
        mat3[T] operator-(const mat3[T]& A) const   # matrix = matrix - matrix
        mat3[T] operator-() const                   # matrix = -matrix

        mat3[T] operator*(const mat3[T]& A) const   # matrix = matrix * matrix
        vec3[T] operator*(const vec3[T]& v) const   # vector = matrix * vector
        mat3[T] operator*(const T s) const          # matrix = matrix * scalar

        mat3[T] operator/(const T s) except+          # matrix = matrix / scalar
        mat3[T] operator%(const T b) except+          # mat = mat % scalar (each component)
        mat3[T] operator%(const mat3[T]& b) except+   # mat = mat % mat

        bool operator==(const mat3[T]& A) const     # matrix == matrix
        bool operator!=(const mat3[T]& A) const     # matrix == matrix

        #void toList(T* dest, bool rowmajor=false) const

        # determinant
        T determinant() const

        # Inversion (*this is never changed, unless dest = *this)
        mat3[T]  inverse() except+
        mat3[T]& inverse(mat3[T]& dest) except+

        # Transposition
        mat3[T]  transpose() const
        mat3[T]& transpose(mat3[T]& dest) const

        mat3[T]& scale(const vec3[T]& s)
        mat3[T]& rotate(T angle, const vec3[T]& axis)

        mat3[T]& ortho(mat3[T]& dest) const
        mat3[T] ortho() const

        void decompose(mat3[T]& rot, vec3[T]& scale) const