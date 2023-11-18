# TODO(@usatiynyan): install
function(sl_target_attach_directory target directory)
    set(target_attach_directory_custom_target ${target}_${directory})
    set(target_attach_directory_src ${CMAKE_CURRENT_SOURCE_DIR}/${directory})
    set(target_attach_directory_dst ${CMAKE_CURRENT_BINARY_DIR}/${directory})

    add_custom_target(
            ${target_attach_directory_custom_target}
            ${CMAKE_COMMAND} -E copy_directory ${target_attach_directory_src} ${target_attach_directory_dst}
            DEPENDS ${target_attach_directory_src}
            COMMENT "${target} copy directory ${target_attach_directory_src} to ${target_attach_directory_dst}" VERBATIM
    )

    add_dependencies(${target} ${target_attach_directory_custom_target})
endfunction()
