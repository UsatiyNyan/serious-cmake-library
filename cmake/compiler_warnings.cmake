# Enables compiler warnings for your project
function(sl_compiler_warnings project_name)
    set(options WARNINGS_AS_ERRORS)
    set(multi_value_args CLANG_WARNINGS GCC_WARNINGS CUDA_WARNINGS MSVC_WARNINGS
        EXTRA_CLANG_WARNINGS EXTRA_GCC_WARNINGS EXTRA_CUDA_WARNINGS EXTRA_MSVC_WARNINGS)
    cmake_parse_arguments(
            ARG
            "${options}"
            ""
            "${multi_value_args}"
            ${ARGN})

    if("${ARG_CLANG_WARNINGS}" STREQUAL "")
        set(ARG_CLANG_WARNINGS
                -Wall
                -Wextra # reasonable and standard
                -Wshadow # warn the user if a variable declaration shadows one from a parent context
                -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps
                # catch hard to track down memory errors
                -Wold-style-cast # warn for c-style casts
                -Wcast-align # warn for potential performance problem casts
                -Wunused # warn on anything being unused
                -Woverloaded-virtual # warn if you overload (not override) a virtual function
                -Wpedantic # warn if non-standard C++ is used
                -Wconversion # warn on type conversions that may lose data
                -Wsign-conversion # warn on sign conversions
                -Wnull-dereference # warn if a null dereference is detected
                -Wdouble-promotion # warn if float is implicit promoted to double
                -Wformat=2 # warn on security issues around functions that format output (ie printf)
                -Wimplicit-fallthrough # warn on statements that fallthrough without an explicit annotation
        )
    endif()

    if("${ARG_GCC_WARNINGS}" STREQUAL "")
        set(ARG_GCC_WARNINGS
                ${ARG_CLANG_WARNINGS}
                -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
                -Wduplicated-cond # warn if if / else chain has duplicated conditions
                -Wduplicated-branches # warn if if / else branches have duplicated code
                -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
                -Wuseless-cast # warn if you perform a cast to the same type
        )
    endif()

    if("${ARG_CUDA_WARNINGS}" STREQUAL "")
        set(ARG_CUDA_WARNINGS
                -Wall
                -Wextra
                -Wunused
                -Wconversion
                -Wshadow
                # TODO add more Cuda warnings
        )
    endif()

    if("${ARG_MSVC_WARNINGS}" STREQUAL "")
        set(ARG_MSVC_WARNINGS
                /W4 # Baseline reasonable warnings
                /w14242 # 'identifier': conversion from 'type1' to 'type2', possible loss of data
                /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
                /w14263 # 'function': member function does not override any base class virtual member function
                /w14265 # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not
                # be destructed correctly
                /w14287 # 'operator': unsigned/negative constant mismatch
                /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside
                # the for-loop scope
                /w14296 # 'operator': expression is always 'boolean_value'
                /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
                /w14545 # expression before comma evaluates to a function which is missing an argument list
                /w14546 # function call before comma missing argument list
                /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
                /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
                /w14555 # expression has no effect; expected expression with side- effect
                /w14619 # pragma warning: there is no warning number 'number'
                /w14640 # Enable warning on thread un-safe static member initialization
                /w14826 # Conversion from 'type1' to 'type2' is sign-extended. This may cause unexpected runtime behavior.
                /w14905 # wide string literal cast to 'LPSTR'
                /w14906 # string literal cast to 'LPWSTR'
                /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
                /permissive- # standards conformance mode for MSVC compiler.
        )
    endif()

    list(APPEND ARG_CLANG_WARNINGS ${ARG_EXTRA_CLANG_WARNINGS})
    list(APPEND ARG_GCC_WARNINGS ${ARG_EXTRA_GCC_WARNINGS})
    list(APPEND ARG_CUDA_WARNINGS ${ARG_EXTRA_CUDA_WARNINGS})
    list(APPEND ARG_MSVC_WARNINGS ${ARG_EXTRA_MSVC_WARNINGS})

    if(ARG_WARNINGS_AS_ERRORS)
        message(TRACE "${project_name} warnings are treated as errors")
        list(APPEND ARG_CLANG_WARNINGS -Werror)
        list(APPEND ARG_GCC_WARNINGS -Werror)
        list(APPEND ARG_MSVC_WARNINGS /WX)
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(PROJECT_WARNINGS_CXX ${ARG_CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(PROJECT_WARNINGS_CXX ${ARG_GCC_WARNINGS})
    elseif(MSVC)
        set(PROJECT_WARNINGS_CXX ${ARG_MSVC_WARNINGS})
    else()
        message(AUTHOR_WARNING "No compiler warnings set for CXX compiler: '${CMAKE_CXX_COMPILER_ID}'")
    endif()

    # use the same warning flags for C
    set(PROJECT_WARNINGS_C "${PROJECT_WARNINGS_CXX}")

    set(PROJECT_WARNINGS_CUDA "${ARG_CUDA_WARNINGS}")

    message(TRACE "${project_name} compiler warnings:\n"
            "CXX=${PROJECT_WARNINGS_CXX},\n"
            "C=${PROJECT_WARNINGS_C},\n"
            "CUDA=${PROJECT_WARNINGS_CUDA}")

    target_compile_options(
            ${project_name}
            INTERFACE
            # C++ warnings
            $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNINGS_CXX}>
            # C warnings
            $<$<COMPILE_LANGUAGE:C>:${PROJECT_WARNINGS_C}>
            # Cuda warnings
            $<$<COMPILE_LANGUAGE:CUDA>:${PROJECT_WARNINGS_CUDA}>)
endfunction()
