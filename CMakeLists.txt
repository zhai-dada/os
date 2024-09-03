cmake_minimum_required(VERSION 3.10)
project(os)

add_definitions(-DDEBUG)

set(DISK_PART "")

set(OS_DIR ${PROJECT_SOURCE_DIR})
set(KERNEL_DIR ${PROJECT_SOURCE_DIR}/kernel)
set(USER_DIR ${PROJECT_SOURCE_DIR}/user)
set(UEFI_DIR ${PROJECT_SOURCE_DIR}/UEFI)
set(APPS_DIR ${PROJECT_SOURCE_DIR}/apps)

set(BIOS ${PROJECT_SOURCE_DIR}/UEFI/OVMF.fd)
set(DISK ${PROJECT_SOURCE_DIR}/disk.img)

set(OUTPUT_APPS_DIR ${CMAKE_BINARY_DIR}/apps)
set(OUTPUT_KERNEL_DIR ${CMAKE_BINARY_DIR}/kernel)
set(OUTPUT_USER_DIR ${CMAKE_BINARY_DIR}/user)
set(OUTPUT_UEFI_DIR ${CMAKE_BINARY_DIR}/UEFI)
set(OUTPUT_DIR ${CMAKE_BINARY_DIR}/output)
set(TMP_DIR ${CMAKE_BINARY_DIR}/tmp)

file(MAKE_DIRECTORY ${OUTPUT_APPS_DIR})
file(MAKE_DIRECTORY ${OUTPUT_KERNEL_DIR})
file(MAKE_DIRECTORY ${OUTPUT_USER_DIR})
file(MAKE_DIRECTORY ${OUTPUT_DIR})
file(MAKE_DIRECTORY ${TMP_DIR})

add_subdirectory(kernel)
add_subdirectory(user)
# add_subdirectory(apps)
# add_subdirectory(UEFI)

add_custom_target(
    disk
    COMMAND sudo cp ${OUTPUT_DIR}/* ${TMP_DIR}
    COMMAND sync
    COMMAND sudo umount ${TMP_DIR}
    DEPENDS ${OUTPUT_DIR}/osImage
    DEPENDS ${OUTPUT_DIR}/userImage
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
)

add_custom_target(
    qemu
	COMMAND sudo qemu-system-x86_64 -bios ${BIOS} -hda ${DISK} -cpu host -enable-kvm -m 4096 -smp 4 -netdev tap,id=mytap,ifname=tap0,script=no,downscript=no -device e1000,netdev=mytap -display vnc=:0 -vga virtio -monitor stdio
    
    DEPENDS disk

    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
)