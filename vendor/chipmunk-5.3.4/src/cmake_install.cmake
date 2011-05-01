# Install script for directory: /home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/src

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/usr/local")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

# Install shared libraries without execute permission?
IF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  SET(CMAKE_INSTALL_SO_NO_EXE "1")
ENDIF(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4")
    FILE(RPATH_CHECK
         FILE "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4"
         RPATH "")
  ENDIF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE SHARED_LIBRARY FILES
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/src/libchipmunk.so.5.3.4"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/src/libchipmunk.so"
    )
  IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4")
    IF(CMAKE_INSTALL_DO_STRIP)
      EXECUTE_PROCESS(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4")
    ENDIF(CMAKE_INSTALL_DO_STRIP)
  ENDIF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libchipmunk.so.5.3.4")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/src/libchipmunk.a")
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/chipmunk" TYPE FILE FILES
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpHashSet.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/chipmunk_private.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/chipmunk_types.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/chipmunk_unsafe.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpSpace.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpArbiter.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/chipmunk_ffi.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpBody.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpVect.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpSpaceHash.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpCollision.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpShape.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpBB.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpArray.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/chipmunk.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/cpPolyShape.h"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/chipmunk/constraints" TYPE FILE FILES
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpSimpleMotor.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpRotaryLimitJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpGrooveJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpDampedRotarySpring.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpPivotJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpDampedSpring.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpPinJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/util.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpSlideJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpConstraint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpRatchetJoint.h"
    "/home/bjorn/src/chipmunk/vendor/chipmunk-5.3.4/include/chipmunk/constraints/cpGearJoint.h"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")

