cmake_minimum_required(VERSION 3.10)
project(os_kernel)

set(C_FLAGS -mcmodel=large -fno-builtin -fno-stack-protector -m64 -fno-PIC -I${PROJECT_SOURCE_DIR}/include/)
set(LD_FLAGS -b elf64-x86-64 -z muldefs -z noexecstack)

# 用于存储所有对象文件的列表
set(OBJECT_FILES_S "")
set(OBJECT_FILES_C "")

file(GLOB_RECURSE USER_SOURCES *.c)
file(GLOB_RECURSE USER_ASSEMBLY_SOURCES *.S)

# 处理 S 文件
foreach(S_FILE ${USER_ASSEMBLY_SOURCES})
    get_filename_component(BASE_NAME ${S_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_USER_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OUTPUT_USER_DIR}/${BASE_NAME}.s
        OUTPUT ${OBJECT_FILE}

        COMMAND gcc -E -I ${USER_DIR}/include/ ${S_FILE} -o ${OUTPUT_USER_DIR}/${BASE_NAME}.s
        COMMAND as --64 ${OUTPUT_USER_DIR}/${BASE_NAME}.s -o ${OBJECT_FILE}

        DEPENDS ${source_file}
        DEPENDS ${S_FILE}

        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_S ${OBJECT_FILE})
endforeach()

# 处理 C 文件
foreach(KERNEL_C_FILE ${USER_SOURCES})
    get_filename_component(BASE_NAME ${KERNEL_C_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_USER_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OBJECT_FILE}

        COMMAND ${CMAKE_C_COMPILER} ${C_FLAGS} -c ${KERNEL_C_FILE} -o ${OBJECT_FILE}

        DEPENDS ${KERNEL_C_FILE}
        
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_C ${OBJECT_FILE})
endforeach()

add_custom_command(
    OUTPUT ${OUTPUT_DIR}/userImage

    COMMAND ld ${LD_FLAGS} -o ${OUTPUT_DIR}/userImage ${OBJECT_FILES_C} -T ${PROJECT_SOURCE_DIR}/user.lds

    DEPENDS ${OBJECT_FILES_C}
    DEPENDS ${OBJECT_FILES_S}
    
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

add_custom_target(
    user
    ALL 
    DEPENDS ${OUTPUT_DIR}/userImage
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)