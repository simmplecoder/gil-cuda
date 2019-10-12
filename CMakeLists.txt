cmake_minimum_required(VERSION 3.10)
project(cuda-gil)

if(NOT DEFINED BOOST_ROOT AND NOT DEFINED ENV{BOOST_ROOT})
    message(ERROR "Please set BOOST_ROOT to root of the boost library collection")
endif()

add_library(boost_include INTERFACE)
target_include_directories(boost_include INTERFACE 
    "${BOOST_ROOT}"
)

add_library(filesystem SHARED IMPORTED)
set_target_properties(filesystem PROPERTIES IMPORTED_LOCATION "${BOOST_ROOT}/stage/lib/libboost_filesystem.so.1.71")

if(NOT EXISTS "${CMAKE_BINARY_DIR}/conan.cmake")
  message(STATUS "Boost.GIL: Downloading conan.cmake from https://github.com/conan-io/cmake-conan")
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
    filesystem     
)

add_executable(test_prog main.cpp)
target_link_libraries(test_prog 
    boost_include     
    CONAN_PKG::libjpeg
    CONAN_PKG::libpng
    CONAN_PKG::libtiff
    filesystem
)