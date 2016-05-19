from cvec3 cimport vec3
from cmat3 cimport mat3
from cmat4 cimport mat4

ctypedef bint bool

cdef extern from "quat.h" namespace 'support3d' nogil:
    cdef cppclass quat[T]:
        # w component
        T w
        # x component
        T x
        # y component
        T y
        # z component
        T z

        # Constructors
        quat()
        quat(T a)
        quat(T aw, T ax, T ay, T az)
        quat(const quat[T]& q)

        quat[T]& set(T aw, T ax, T ay, T az)
        void get(T& aw, T& ax, T& ay, T& az) const

        # quat[T]& operator+=(const quat[T]& q)
        # quat[T]& operator-=(const quat[T]& q)
        # quat[T]& operator*=(const T r)
        # quat[T]& operator/=(const T r)

        quat[T] operator+(const quat[T]& b) const
        quat[T] operator-(const quat[T]& b) const
        quat[T] operator-() const
        quat[T] operator*(const T r) const
        quat[T] operator*(const quat[T]& b) const
        quat[T] operator/(const T r) const

        bool operator==(const quat[T]& q) const
        bool operator!=(const quat[T]& q) const

        T abs() const

        quat[T]  normalize() const
        quat[T]& normalize(quat[T]& dest)

        T dot(const quat[T]& q) const

        quat[T]  conjugate() const
        quat[T]& conjugate(quat[T]& dest)

        quat[T]  inverse() const
        quat[T]& inverse(quat[T]& dest)

        quat[T]& fromMat(const mat3[T]& m)
        quat[T]& fromMat(const mat4[T]& m)

        void toMat3(mat3[T]& mat) const
        void toMat4(mat4[T]& mat) const
        mat3[T] toMat3() const
        mat4[T] toMat4() const

        void toAngleAxis(T& angle, vec3[T]& axis) const
        quat[T]& fromAngleAxis(T angle, const vec3[T]& axis)

        void log(quat[T]& q)
        quat[T] log() const

        void exp(quat[T]& q)
        quat[T] exp() const

        void rotateVec(const vec3[T]& v, vec3[T]& dest) const
        vec3[T] rotateVec(const vec3[T]& v) const

        ###### Alternatives to operators #######

        quat[T]& add(const quat[T]& a, const quat[T]& b)
        quat[T]& sub(const quat[T]& a, const quat[T]& b)
        quat[T]& neg(const quat[T]& a)
        quat[T]& mul(const T r, const quat[T]& a)
        quat[T]& mul(const quat[T]& a, const quat[T]& b)
        
    quat[double] slerp(double t, const quat[double]& q0, const quat[double]& q1, bool shortest)
    quat[double] squad(double t, const quat[double]& a, const quat[double]& b,
                                 const quat[double]& c, const quat[double]& d)