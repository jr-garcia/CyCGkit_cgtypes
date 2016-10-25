ctypedef bint bool

cdef extern from "vec3.h" namespace 'support3d' nogil:
    cdef cppclass vec3[T]:
        T x
        T y
        T z

        T epsilon

        # Constructors
        vec3()
        vec3(const T a)
        vec3(const T ax,const T ay)
        vec3(const T ax,const T ay,const T az)
        vec3(const vec3[T]& v)
        # Use defaults for copy constructor and assignment

        # Conversion operators
        # (vec3[float] and vec3<double> can now be mixed)
        #operator vec3[float]() const
        #operator vec3[double]() const

        vec3[T]& set(const T ax, const T ay, const T az)
        vec3[T]& set_polar(const T r, const T theta, const T phi)
        void get(T& ax, T& ay, T& az) const
        void get_polar(T& r, T& theta, T& phi) const

        T& operator[]()
        const T& operator[](int) const

        #vec3[T]& operator+=(const vec3[T]& v)
        #vec3[T]& operator-=(const vec3[T]& v)
        #vec3[T]& operator*=(const T r)
        #vec3[T]& operator/=(const T r)
        #vec3[T]& operator%=(const T r)
        #vec3[T]& operator%=(const vec3[T]& b)

        vec3[T] operator+(const vec3[T]& b) const # vec = vec + vec
        vec3[T] operator-(const vec3[T]& b) const # vec = vec - vec
        vec3[T] operator-() const                 # vec = -vec
        vec3[T] operator*(const T r) const        # vec = vec * scalar
        T operator*(const vec3[T]& b) const       # scalar = vec * vec (dot prod.)
        vec3[T] operator^(const vec3[T]& b) const # vec = vec * vec (cross prod.)
        vec3[T] operator/(const T r) except +        # vec = vec / scalar
        vec3[T] operator%(const T b) const        # vec = vec % scalar (each component)
        vec3[T] operator%(const vec3[T]& b) const # vec = vec % vec

        bool operator==(const vec3[T]& b) const
        bool operator!=(const vec3[T]& b) const
        bool operator<(const vec3[T]& b) const
        bool operator>(const vec3[T]& b) const
        bool operator<=(const vec3[T]& b) const
        bool operator>=(const vec3[T]& b) const
        bool nullvec() const                      # *this == 0

        T length() const

        vec3[T]  normalize() except+
        vec3[T]& normalize(vec3[T]& dest) except+
        # Return a vector that's perpendicular to this
        vec3[T]  ortho() const

        vec3[T]  reflect(const vec3[T]& n) const
        vec3[T]  refract(const vec3[T]& n, T eta) const

        # Return component/index with maximum value
        T max() const
        int maxIndex() const
        # Return component/index with minimum value
        T min() const
        int minIndex() const
        # Return component/index with maximum absolute value
        T maxAbs() const
        int maxAbsIndex() const
        # Return component/index with minimum absolute value
        T minAbs() const
        int minAbsIndex() const

        #char* to_str(char *s) const

        inline vec3[T] cross(const vec3[T]& b) const # vec3 = this x b

        ########## Alternatives to operators ##########/

    inline vec3[double]& add(const vec3[double]& a, const vec3[double]& b)   # this = a+b
    inline vec3[double]& neg(const vec3[double]& a)                     # this = -a
    inline vec3[double]& sub(const vec3[double]& a, const vec3[double]& b)   # this = a-b
    inline vec3[double]& mul(const vec3[double]& a, const double r)          # this = a*r
    inline vec3[double]& div(const vec3[double]& a, const double r)          # this = a/r
    #inline vec3[double]& cross(const vec3[double]& a, const vec3[double]& b) # this = a*b
    inline vec3[double] mul 'operator*'(const double r,const vec3[double]& v)

    inline double angle(const vec3[double] &a, const vec3[double] &b) except+
    inline double sangle(const vec3[double] &a, const vec3[double] &b, const vec3[double] &axis) except+