cmake_minimum_required(VERSION 3.10)
project(os_kernel)

set(C_FLAGS -mcmodel=large -fno-builtin -fno-stack-protector -fno-pie -fno-pic -fno-common -std=gnu99 -nostartfiles -Wno-address-of-packed-member -m64 -O0 -I${PROJECT_SOURCE_DIR}/include/)
set(LD_FLAGS -b elf64-x86-64 -z muldefs -z noexecstack)

# 用于存储所有对象文件的列表
set(OBJECT_FILES_S "")
set(OBJECT_FILES_C "")

file(GLOB_RECURSE KERNEL_SOURCES *.c)
file(GLOB_RECURSE KERNEL_ASSEMBLY_SOURCES *.S)

# 处理 S 文件
foreach(S_FILE ${KERNEL_ASSEMBLY_SOURCES})
    get_filename_component(BASE_NAME ${S_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.s
        OUTPUT ${OBJECT_FILE}

        COMMAND gcc -E -I ${KERNEL_DIR}/include/ ${S_FILE} -o ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.s
        COMMAND as --64 ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.s -o ${OBJECT_FILE}

        DEPENDS ${source_file}
        DEPENDS ${S_FILE}

        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_S ${OBJECT_FILE})
endforeach()

# 处理 C 文件
foreach(KERNEL_C_FILE ${KERNEL_SOURCES})
    get_filename_component(BASE_NAME ${KERNEL_C_FILE} NAME_WE)
    set(OBJECT_FILE ${OUTPUT_KERNEL_DIR}/${BASE_NAME}.o)
    add_custom_command(
        OUTPUT ${OBJECT_FILE}

        COMMAND ${CMAKE_C_COMPILER} ${C_FLAGS} -c ${KERNEL_C_FILE} -o ${OBJECT_FILE}

        DEPENDS ${KERNEL_C_FILE}
        
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
    list(APPEND OBJECT_FILES_C ${OBJECT_FILE})
endforeach()

add_custom_command(
    OUTPUT ${OUTPUT_DIR}/osImage

    COMMAND ld ${LD_FLAGS} -o ${OUTPUT_DIR}/osImage ${OUTPUT_KERNEL_DIR}/head.o ${OUTPUT_KERNEL_DIR}/entry.o ${OUTPUT_KERNEL_DIR}/apu_boot.o ${OBJECT_FILES_C} -T ${PROJECT_SOURCE_DIR}/kernel.lds

    DEPENDS ${OBJECT_FILES_C}
    DEPENDS ${OBJECT_FILES_S}
    
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

add_custom_target(
    kernel
    ALL 

    DEPENDS ${OUTPUT_DIR}/osImage
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)

