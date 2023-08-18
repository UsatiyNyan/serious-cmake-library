include(cmake/system_link.cmake)
include(cmake/CPM.cmake)

macro(sl_gtest_prologue version)
    cpmaddpackage("gh:google/googletest#${version}")
    include(GoogleTest)
endmacro()

function(sl_add_gtest lib name)
    add_executable(${lib}_${name}_test src/${name}_test.cpp)
    target_link_libraries(${lib}_${name}_test PRIVATE ${lib})
    sl_target_link_system_library(${lib}_${name}_test PRIVATE gtest_main)
    gtest_discover_tests(${lib}_${name}_test)
endfunction()
