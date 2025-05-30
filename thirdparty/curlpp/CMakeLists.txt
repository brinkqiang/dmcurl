cmake_minimum_required(VERSION 3.21)

project(curlpp) 

set(CURLPP_LIBS "")

# In response to CMake 3.0 generating warnings regarding policy CMP0042,
# the OSX RPATH settings have been updated per recommendations found
# in the CMake Wiki:
#  http://www.cmake.org/Wiki/CMake_RPATH_handling#Mac_OS_X_and_the_RPATH
if(POLICY CMP0042)
    cmake_policy(SET CMP0042 NEW) # MACOSX_RPATH
    set(CMAKE_MACOSX_RPATH TRUE)
endif()

# for unix platform, define install directories.
include(GNUInstallDirs)

set(CMAKE_CXX_STANDARD 11) # C++11...
set(CMAKE_CXX_STANDARD_REQUIRED ON) #...is required...
set(CMAKE_CXX_EXTENSIONS OFF) #...without compiler extensions like gnu++11

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

# Conan.io integration
if(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.cmake)
    include(${CMAKE_CURRENT_SOURCE_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()
endif()

# extra (pkg-config-related files)
add_subdirectory(extras)

#########################################################################################
# Look for dependencies

# Documented at https://cmake.org/cmake/help/v3.0/module/FindCURL.html?highlight=curlpp
# Seems simple.

message(STATUS "Looking for CURL")
set(CURL_VERSION_STRING "7.61.1")
set(CURL_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/../curl/include")
set(CURL_LIBRARIES "libcurl")

message(STATUS "Found CURL version: ${CURL_VERSION_STRING}")
message(STATUS "Using CURL include dir(s): ${CURL_INCLUDE_DIRS}")
message(STATUS "Using CURL lib(s): ${CURL_LIBRARIES}")

# All following targets should search these directories for headers
include_directories( 
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${CURL_INCLUDE_DIRS}
)

#########################################################################################
# Define Targets

# If building on windows, install path will be in build/winbuild
if(CMAKE_SYSTEM MATCHES "Windows")
   set(CMAKE_INSTALL_PREFIX "winbuild")
endif()

file(GLOB_RECURSE HeaderFileList "${CMAKE_CURRENT_SOURCE_DIR}/include/*")
file(GLOB_RECURSE SourceFileList "${CMAKE_CURRENT_SOURCE_DIR}/src/*")
add_library(${PROJECT_NAME} SHARED ${HeaderFileList} ${SourceFileList})
target_link_libraries(${PROJECT_NAME} ${CURL_LIBRARIES} ${CONAN_LIBS})
set_target_properties(${PROJECT_NAME} PROPERTIES SOVERSION 1 VERSION 1.0.0)

add_library(${PROJECT_NAME}_static STATIC ${HeaderFileList} ${SourceFileList})

# Make sure that on unix-platforms shared and static libraries have
# the same root name, but different suffixes.
#
#  (solution taken from https://cmake.org/Wiki/CMake_FAQ#How_do_I_make_my_shared_and_static_libraries_have_the_same_root_name.2C_but_different_suffixes.3F)
# 
# Making shared and static libraries have the same root name, but different suffixes
SET_TARGET_PROPERTIES(${PROJECT_NAME}_static PROPERTIES OUTPUT_NAME ${PROJECT_NAME})
# Now the library target "curlpp_static" will be named "curlpp.lib" with MS tools.
# This conflicts with the "curlpp.lib" import library corresponding to "curlpp.dll",
# so we add a "lib" prefix (which is default on other platforms anyway):
SET_TARGET_PROPERTIES(${PROJECT_NAME}_static PROPERTIES PREFIX "lib")
target_link_libraries(${PROJECT_NAME}_static ${CURL_LIBRARIES} ${CONAN_LIBS})

# install headers
install(DIRECTORY include/utilspp/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/utilspp")
install(DIRECTORY include/curlpp/ DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/curlpp")

install(TARGETS ${PROJECT_NAME} ${PROJECT_NAME}_static
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})

set(CURLPP_LIBS ${PROJECT_NAME})
mark_as_advanced(${CURLPP_LIBS})