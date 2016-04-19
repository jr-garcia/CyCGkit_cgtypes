from cvec3 cimport *

cdef extern from "vec4.h" namespace 'support3d':
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
        explicit vec4(T a)
        vec4(T ax, T ay)
        vec4(T ax, T ay, T az)
        vec4(T ax, T ay, T az, T aw)
        vec4(const vec4<T>& v)