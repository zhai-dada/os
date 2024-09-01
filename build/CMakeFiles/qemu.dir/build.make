# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/zhai/myspace/os

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/zhai/myspace/os/build

# Utility rule file for qemu.

# Include any custom commands dependencies for this target.
include CMakeFiles/qemu.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/qemu.dir/progress.make

CMakeFiles/qemu:
	cd /home/zhai/myspace/os && sudo qemu-system-x86_64 -bios /home/zhai/myspace/os/UEFI/OVMF.fd -hda /home/zhai/myspace/os/disk.img -cpu host -enable-kvm -m 4096 -smp 4 -netdev tap,id=mytap,ifname=tap0,script=no,downscript=no -device e1000,netdev=mytap -display vnc=:0 -vga virtio -monitor stdio

qemu: CMakeFiles/qemu
qemu: CMakeFiles/qemu.dir/build.make
.PHONY : qemu

# Rule to build all files generated by this target.
CMakeFiles/qemu.dir/build: qemu
.PHONY : CMakeFiles/qemu.dir/build

CMakeFiles/qemu.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/qemu.dir/cmake_clean.cmake
.PHONY : CMakeFiles/qemu.dir/clean

CMakeFiles/qemu.dir/depend:
	cd /home/zhai/myspace/os/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/zhai/myspace/os /home/zhai/myspace/os /home/zhai/myspace/os/build /home/zhai/myspace/os/build /home/zhai/myspace/os/build/CMakeFiles/qemu.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/qemu.dir/depend

