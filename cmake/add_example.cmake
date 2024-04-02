function(sl_add_example lib name)
    set(example_executable ${lib}_${name})
    add_executable(${example_executable} src/${name}.cpp)
    target_link_libraries(${example_executable} PRIVATE ${lib})

    if (NOT TARGET ${lib}_examples)
        add_custom_target(${lib}_examples)
    endif()

    add_dependencies(${lib}_examples ${example_executable})
endfunction()
