cmake_minimum_required(VERSION 3.10)
project(cuda-gil)

if(NOT DEFINED BOOST_ROOT AND NOT DEFINED ENV{BOOST_ROOT})
    message(ERROR "Please set BOOST_ROOT")
endif()

add_library(boost INTERFACE)
set_target_properties(boost PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${BOOST_ROOT}"
    INTERFACE_LINK_LIBRARIES "${BOOST_ROOT}/stage/lib/libboost_unit_test_framework.so;${BOOST_ROOT}/stage/lib/libboost_filesystem.so")

# taken from https://github.com/boostorg/gil/blob/develop/CMakeLists.txt
if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
  file(DOWNLOAD "https://raw.githubusercontent.com/conan-io/cmake-conan/v0.14/conan.cmake"
    "${CMAKE_BINARY_DIR}/conan.cmake")
endif()
include(${CMAKE_BINARY_DIR}/conan.cmake)
conan_cmake_run(CONANFILE conanfile.txt BASIC_SETUP CMAKE_TARGETS BUILD missing)

add_library(io_dependencies INTERFACE)
target_link_libraries(io_dependencies INTERFACE
    CONAN_PKG::libjpeg
    CONAN_PKG::libpng
    CONAN_PKG::libtiff
)

add_executable(test_prog main.cpp)
target_link_libraries(test_prog 
    io_dependencies
    boost
)