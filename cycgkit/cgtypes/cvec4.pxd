ctypedef bint bool

cdef extern from "vec4.h" namespace 'support3d' nogil:
    cdef cppclass vec4[T]:
        T x
        T y
        T z
        T w
        #  static char leftBracket
        #  static char rightBracket
        #  static char separator
        #  static T epsilon

        # Constructors
        vec4()
        vec4(T a)
        vec4(T ax, T ay)
        vec4(T ax, T ay, T az)
        vec4(T ax, T ay, T az, T aw)
        vec4(const vec4[T]& v)

        vec4[T]& set(const T ax, const T ay, const T az, T aw)
        void get(T& ax, T& ay, T& az, T& aw) const

        #T& operator[]()
        const T& operator[](int) const
        
        vec4[T] operator+(const vec4[T]& b) const # vec = vec + vec
        vec4[T] operator-(const vec4[T]& b) const # vec = vec - vec
        vec4[T] operator-() const                 # vec = -vec
        vec4[T] operator*(const T r) const        # vec = vec * scalar
        T operator*(const vec4[T]& b) const       # scalar = vec * vec (dot prod.)
        vec4[T] operator^(const vec4[T]& b) const # vec = vec * vec (cross prod.)
        vec4[T] operator/(const T r) except +     # vec = vec / scalar
        vec4[T] operator%(const T b) const        # vec = vec % scalar (each component)
        vec4[T] operator%(const vec4[T]& b) const # vec = vec % vec

        bool operator==(const vec4[T]& b) const
        bool operator!=(const vec4[T]& b) const
        bool operator<(const vec4[T]& b) const
        bool operator>(const vec4[T]& b) const
        bool operator<=(const vec4[T]& b) const
        bool operator>=(const vec4[T]& b) const
        bool nullvec() const                      # *this == 0

        T length() const
        
        vec4[T]  normalize() const
        vec4[T]& normalize(vec4[T]& dest)

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

    ########## Alternatives to operators ##########/

    vec4[double]& add(const vec4[double]& a, const vec4[double]& b)   # this = a+b
    vec4[double]& sub(const vec4[double]& a, const vec4[double]& b)   # this = a-b
    vec4[double]& neg(const vec4[double]& a)                     # this = -a
    vec4[double]& mul(const vec4[double]& a, constdoubler)          # this = a*r
    vec4[double]& div(const vec4[double]& a, constdoubler)          # this = a/r