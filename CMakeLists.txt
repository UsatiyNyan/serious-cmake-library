cmake_minimum_required(VERSION 3.21)

project(
        serious-cmake-library
        VERSION 0.0.1
        DESCRIPTION "cmake packaging and utilities"
        HOMEPAGE_URL "TODO"
)

include(cmake/project_prologue.cmake)
include(cmake/CPM.cmake)
include(cmake/system_link.cmake)
include(cmake/add_test.cmake)
