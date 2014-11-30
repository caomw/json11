CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(json11)

SET(LIBRARY_VERSION_STRING 0.1.0)

SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/bin)

# Compilation flags
IF (MSVC)
  IF (MSVC_VERSION VERSION_LESS "1800")
    MESSAGE(FATAL_ERROR "Update to Visual Studio version which fully support C++11 (>= VS2013)")
  ENDIF()
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W4 /GR-")
ELSE()
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fno-rtti -fno-exceptions")

  IF(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    IF(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.7")
      MESSAGE(FATAL_ERROR "Update to a GCC version which fully supports C++11 (>= 4.7)")
    ELSE()
      SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
    ENDIF()
  ENDIF()

  IF(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
  ENDIF()
ENDIF()

IF (CMAKE_HOST_APPLE AND (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -stdlib=libc++")
ENDIF()


INSTALL(FILES json11.hpp DESTINATION include)

ADD_LIBRARY(json11static STATIC json11.cpp)
SET_TARGET_PROPERTIES(json11static PROPERTIES
                      VERSION ${LIBRARY_VERSION_STRING}
                      OUTPUT_NAME json11
                      CLEAN_DIRECT_OUTPUT 1)
INSTALL(TARGETS json11static DESTINATION lib)

SET (PROJECT_BUILD_SHARED NO CACHE BOOL "Set to true to build shared version
of the library")
IF(ROJECT_BUILD_SHARED)
  ADD_LIBRARY(json11shared SHARED json11.cpp)
  SET_TARGET_PROPERTIES(json11shared PROPERTIES
                        VERSION ${LIBRARY_VERSION_STRING}
                        OUTPUT_NAME json11
                        CLEAN_DIRECT_OUTPUT 1)
  INSTALL(TARGETS json11shared DESTINATION lib)
ENDIF()

SET (PROJECT_BUILD_TESTS YES CACHE BOOL "Set to true to build tests")
IF (PROJECT_BUILD_TESTS)
  ADD_EXECUTABLE(tests test.cpp)
  ADD_DEPENDENCIES(tests json11static)
  TARGET_LINK_LIBRARIES(tests json11static)
ENDIF()
