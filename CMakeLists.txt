cmake_minimum_required(VERSION 3.21)

project(dmcurl)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
include(cmake/ModuleImport.cmake)
include(cmake/ModuleCompileOptions.cmake)
ModuleSetCompileOptions()

set(DMCURL_VERSION_MAJOR "1")
set(DMCURL_VERSION_MINOR "0")
set(DMCURL_VERSION_PATCH "1")
set(DMCURL_VERSION "${DMCURL_VERSION_MAJOR}.${DMCURL_VERSION_MINOR}.${DMCURL_VERSION_PATCH}")

message(STATUS "VERSION: ${DMCURL_VERSION}")

add_definitions(-DUSE_DMCURL)
add_definitions(-DNOMINMAX)
ModuleInclude("dmformat" "thirdparty/dmformat")
ModuleImport("mbedtls" "thirdparty/mbedtls")
ModuleImport("curl" "thirdparty/curl")
ModuleImport("curlpp" "thirdparty/curlpp")

ExeImport("test" "libcurl;curlpp;mbedcrypto;mbedx509;mbedtls")

