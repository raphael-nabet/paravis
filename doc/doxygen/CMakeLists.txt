# Copyright (C) 2010-2026  CEA, EDF
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
# See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
#

SALOME_CONFIGURE_FILE(doxyfile.in doxyfile)
SALOME_CONFIGURE_FILE(static/header.html.in static/header.html)

SET(_doxy_post_commands)
IF(APPLE)
  SET(_doxy_post_commands
      COMMAND ${CMAKE_COMMAND}
              -DBUILD_DIR=${CMAKE_CURRENT_BINARY_DIR}/doc_api
              -P ${CMAKE_CURRENT_SOURCE_DIR}/set_dot_permissions.cmake)
ENDIF()

ADD_CUSTOM_TARGET(doxy_doc ALL
    COMMAND ${DOXYGEN_EXECUTABLE}
    ${_doxy_post_commands}
    VERBATIM
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

INSTALL(CODE "EXECUTE_PROCESS(COMMAND \"${CMAKE_COMMAND}\" --build ${PROJECT_BINARY_DIR} --target doxy_doc)")

# Conserver les permissions des .dot à l'installation sur macOS
SET(_doxy_install_dot_rule)
IF(APPLE)
  SET(_doxy_install_dot_rule
      PATTERN "*.dot" PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE)
ENDIF()

INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/doc_api/html/
        DESTINATION ${SALOME_INSTALL_DOC}/dev/PARAVIS/api
        PATTERN "*.md5" EXCLUDE
        PATTERN "*.map" EXCLUDE
        ${_doxy_install_dot_rule})

SET(MAKE_CLEAN_FILES doc_api)
SET_DIRECTORY_PROPERTIES(PROPERTIES ADDITIONAL_MAKE_CLEAN_FILES "${MAKE_CLEAN_FILES}")
