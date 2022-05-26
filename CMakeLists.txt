cmake_minimum_required(VERSION 3.2)

PROJECT(dmcurl)

LIST(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
INCLUDE(cmake/ModuleImport.cmake)
INCLUDE(cmake/ModuleCompileOptions.cmake)
ModuleSetCompileOptions()

SET(DMCURL_VERSION_MAJOR "1")
SET(DMCURL_VERSION_MINOR "0")
SET(DMCURL_VERSION_PATCH "1")
SET(DMCURL_VERSION "${DMCURL_VERSION_MAJOR}.${DMCURL_VERSION_MINOR}.${DMCURL_VERSION_PATCH}")

MESSAGE(STATUS "VERSION: ${DMCURL_VERSION}")

ADD_DEFINITIONS(-DUSE_DMCURL)
ADD_DEFINITIONS(-DNOMINMAX)
ModuleInclude("dmformat" "thirdparty/dmformat")
ModuleImport("mbedtls" "thirdparty/mbedtls")
ModuleImport("curl" "thirdparty/curl")
ModuleImport("curlpp" "thirdparty/curlpp")

ExeImport("test" "libcurl;curlpp;mbedcrypto;mbedx509;mbedtls")

