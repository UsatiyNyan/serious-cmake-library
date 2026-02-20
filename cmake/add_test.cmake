include("${CMAKE_CURRENT_LIST_DIR}/system_link.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/CPM.cmake")

macro(sl_gtest_prologue version)
    cpmaddpackage("gh:google/googletest#${version}")
    include(GoogleTest)
endmacro()

function(sl_add_gtest lib name)
    set(test_executable ${lib}_${name}_test)
    add_executable(${test_executable} src/${name}_test.cpp)
    target_link_libraries(${lib}_${name}_test PRIVATE ${lib})
    sl_target_link_system_library(${lib}_${name}_test PRIVATE gtest_main)
    gtest_discover_tests(${lib}_${name}_test)

    if (NOT TARGET ${lib}_tests)
        add_custom_target(${lib}_tests)
    endif()

    add_dependencies(${lib}_tests ${test_executable})
endfunction()
