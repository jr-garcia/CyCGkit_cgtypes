from cvec3 cimport vec3
from cvec4 cimport vec4
from cmat3 cimport mat3

ctypedef bint bool

cdef extern from "mat4.h" namespace 'support3d' nogil:
    cdef cppclass mat4[T]:
        # Constructors
        mat4()
        mat4(T v)
        mat4(T a, T b, T c, T d,
            T e, T f, T g, T h,
            T i, T j, T k, T l,
            T m, T n, T o, T p)
        mat4(const mat4[T]& A)

        T& at(short i, short j)

        # set_ and get_ methods
        mat4[T]& setIdentity()
        mat4[T]& setNull()
        mat4[T]& setRow(short i, const vec4[T]& r)
        mat4[T]& setRow(short i, const T a, const T b, const T c, const T d)
        mat4[T]& setColumn(short i, const vec4[T]& c)
        mat4[T]& setColumn(short i, const T a, const T b, const T c, const T d)
        mat4[T]& setDiag(const vec4[T]& d)
        mat4[T]& setDiag(T a, T b, T c, T d)
        vec4[T] getRow(short i) const
        void     getRow(short i, vec4[T]& dest) const
        void     getRow(short i, T& a, T& b, T& c, T& d) const
        vec4[T] getColumn(short i) const
        void     getColumn(short i, vec4[T]& dest) const
        void     getColumn(short i, T& a, T& b, T& c, T& d) const
        vec4[T] getDiag() const
        void     getDiag(vec4[T]& dest) const
        void     getDiag(T& a, T& b, T& c, T& d) const

        mat4[T]& setTranslation(const vec3[T]& t);
        mat4[T]& setRotation(T angle, const vec3[T]& axis)
        mat4[T]& setScaling(const vec3[T]& s)
        mat4[T]& setOrthographic(T left, T right, T bottom, T top, T nearval, T farval);
        mat4[T]& setFrustum(T left, T right, T bottom, T top, T near_, T far_);
        mat4[T]& setPerspective(T fovy, T aspect, T near_, T far_);
        #mat4[T]& setLookAt(const vec3[T]& pos, const vec3[T]& target, const vec3[T]& up=vec3[T](0,0,1));
        mat4[T]& setMat3(const mat3[T]& m3);
        mat3[T]  getMat3() const;
        mat3[T]& getMat3(mat3[T]& dest) const;

        mat4[T] operator+(const mat4[T]& A) const   # matrix = matrix + matrix
        mat4[T] operator-(const mat4[T]& A) const   # matrix = matrix - matrix
        mat4[T] operator-() const                   # matrix = -matrix

        mat4[T] operator*(const mat4[T]& A) const   # matrix = matrix * matrix
        vec3[T] operator*(const vec3[T]& v) const   # vector = matrix * vector
        vec4[T] operator*(const vec4[T]& v) const   # vector = matrix * vector
        mat4[T] operator*(const T s) const          # matrix = matrix * scalar

        mat4[T] operator/(const T s) const          # matrix = matrix / scalar
        mat4[T] operator%(const T b) const          # mat = mat % scalar (each component)
        mat4[T] operator%(const mat4[T]& b) const   # mat = mat % mat

        bool operator==(const mat4[T]& A) const     # matrix == matrix
        bool operator!=(const mat4[T]& A) const     # matrix == matrix

        #void toList(T* dest, bool rowmajor=false) const

        # determinant
        T determinant() const

        # Inversion (*this is never changed, unless dest = *this)
        mat4[T]  inverse() const
        mat4[T]& inverse(mat4[T]& dest) const

        # Transposition
        mat4[T]  transpose() const
        mat4[T]& transpose(mat4[T]& dest) const

        mat4[T]& translate(const vec3[T]& t);
        mat4[T]& scale(const vec3[T]& s)
        mat4[T]& rotate(T angle, const vec3[T]& axis)

        mat4[T]& ortho(mat4[T]& dest) const
        mat4[T] ortho() const

        void decompose(vec3[T]& t, mat4[T]& rot, vec3[T]& scale) const