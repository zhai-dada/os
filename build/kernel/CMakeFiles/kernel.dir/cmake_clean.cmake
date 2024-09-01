file(REMOVE_RECURSE
  "../output/osImage"
  "CMakeFiles/kernel"
  "apu_boot.o"
  "apu_boot.s"
  "entry.o"
  "entry.s"
  "head.o"
  "head.s"
  "start.o"
)

# Per-language clean rules from dependency scanning.
foreach(lang )
  include(CMakeFiles/kernel.dir/cmake_clean_${lang}.cmake OPTIONAL)
endforeach()
