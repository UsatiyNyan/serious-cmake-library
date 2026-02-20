function(sl_detect_machine_cpu out_var)
    message(TRACE "CMAKE_HOST_SYSTEM_PROCESSOR=${CMAKE_HOST_SYSTEM_PROCESSOR}")

    set(_sl_detected_machine_cpu "")

    if((CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "aarch64") OR
       (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm") OR
       (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64"))
        set(_sl_detected_machine_cpu "arm")
    endif()

    if(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
        set(_sl_detected_machine_cpu "x86_64")
    endif()

    message(TRACE "SL_DETECTED_MACHINE_CPU=${_sl_detected_machine_cpu}")

    set(${out_var} ${_sl_detected_machine_cpu} PARENT_SCOPE)
endfunction()

function(sl_detect_compiler out_var)
    message(TRACE "CMAKE_CXX_COMPILER_ID=${CMAKE_CXX_COMPILER_ID}")

    set(_sl_detected_compiler "")

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        set(_sl_detected_compiler "clang")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(_sl_detected_compiler "gcc")
    elseif(MSVC)
        set(_sl_detected_compiler "msvc")
    endif()

    message(TRACE "SL_DETECTED_COMPILER=${_sl_detected_compiler}")

    set(${out_var} "${_sl_detected_compiler}" PARENT_SCOPE)
endfunction()

function(sl_detect_os out_var)
    message(TRACE "CMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")

    set(_sl_detected_os "")

    if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
        set(_sl_detected_os "linux")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
        set(_sl_detected_os "macos")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(_sl_detected_os "windows")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "Android")
        set(_sl_detected_os "android")
    elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")
        set(_sl_detected_os "ios")
    endif()

    message(TRACE "SL_DETECTED_OS=${_sl_detected_os}")

    set(${out_var} "${_sl_detected_os}" PARENT_SCOPE)
endfunction()
