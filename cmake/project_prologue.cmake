include(cmake/prevent_in_source_builds.cmake)

# This function should be called before project(...)
function(sl_project_prologue)
    set(_options
            # defaults to false
            CXX_EXTENSIONS)
    set(_one_value_args
            # only set if not defined
            CXX_STANDARD
            C_STANDARD)
    set(_multi_value_args "")
    cmake_parse_arguments(
            _project_prologue
            "${_options}"
            "${_one_value_args}"
            "${_multi_value_args}"
            "${ARGN}"
    )

    if (NOT DEFINED CMAKE_CXX_STANDARD)
        set(CMAKE_CXX_STANDARD "${_project_prologue_CXX_STANDARD}" PARENT_SCOPE)
    endif ()

    if (NOT DEFINED CMAKE_C_STANDARD)
        set(CMAKE_C_STANDARD "${_project_prologue_C_STANDARD}" PARENT_SCOPE)
    endif ()

    # NOTE(@cpp-best-practices):
    #  strongly encouraged to enable this globally to avoid conflicts between
    #  -Wpedantic being enabled and -std=c++20 and -std=gnu++20 for example
    #  when compiling with PCH enabled
    set(CMAKE_CXX_EXTENSIONS "${_project_prologue_CXX_EXTENSIONS}" PARENT_SCOPE)

    sl_prevent_in_source_builds()
endfunction()
