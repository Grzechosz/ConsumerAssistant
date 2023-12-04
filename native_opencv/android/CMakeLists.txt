cmake_minimum_required(VERSION 3.4.1)

project(consciousconsumer)

# Add include directories for OpenCV
include_directories(../include)

# Add the OpenCV shared library to your project
add_library(libopencv_java4 SHARED IMPORTED)
set_target_properties(libopencv_java4 PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_SOURCE_DIR}/src/main/libraries/${ANDROID_ABI}/libopencv_java4.so)

# Link your target against the OpenCV library
add_library(native_opencv SHARED ../lib/native_opencv.cpp)
target_link_libraries(native_opencv libopencv_java4)