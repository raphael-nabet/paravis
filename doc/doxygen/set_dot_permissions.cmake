# Copyright (C) 2010-2026 CEA, EDF
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
#
# Positionne OWNER_READ OWNER_WRITE OWNER_EXECUTE sur tous les *.dot sous BUILD_DIR.

cmake_minimum_required(VERSION 3.0)

set(DOT_FILE_PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)

if(NOT DEFINED BUILD_DIR)
  message(FATAL_ERROR "BUILD_DIR non défini : cmake -DBUILD_DIR=<dir> -P set_dot_permissions.cmake")
endif()

if(NOT IS_DIRECTORY "${BUILD_DIR}")
  message(STATUS "set_dot_permissions : ${BUILD_DIR} absent, rien à faire")
  return()
endif()

file(GLOB_RECURSE _dot_files "${BUILD_DIR}/*.dot")
if(NOT _dot_files)
  message(STATUS "set_dot_permissions : aucun fichier .dot sous ${BUILD_DIR}")
  return()
endif()

if(NOT CMAKE_VERSION VERSION_LESS 3.19)
  file(CHMOD ${_dot_files} FILE_PERMISSIONS ${DOT_FILE_PERMISSIONS})
else()
  # Repli CMake < 3.19 : déplacement puis recopie avec les permissions voulues
  set(_tmp_dir "${BUILD_DIR}/.dot_perms_tmp")
  file(REMOVE_RECURSE "${_tmp_dir}")
  file(MAKE_DIRECTORY "${_tmp_dir}")
  foreach(_f IN LISTS _dot_files)
    get_filename_component(_name "${_f}" NAME)
    get_filename_component(_dir  "${_f}" DIRECTORY)
    file(RENAME "${_f}" "${_tmp_dir}/${_name}")
    file(COPY "${_tmp_dir}/${_name}"
         DESTINATION "${_dir}"
         FILE_PERMISSIONS ${DOT_FILE_PERMISSIONS})
    file(REMOVE "${_tmp_dir}/${_name}")
  endforeach()
  file(REMOVE_RECURSE "${_tmp_dir}")
endif()

list(LENGTH _dot_files _n)
message(STATUS "set_dot_permissions : ${_n} fichier(s) .dot mis en ${DOT_FILE_PERMISSIONS}")

