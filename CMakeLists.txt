cmake_minimum_required (VERSION 2.8)
cmake_policy (VERSION 2.8)
project (nectar)
enable_testing ()


# Project info
set (APP_NAME "Nectar")
set (VERSION "0.1.0")
set (VERSION_INFO "Prerelease")
set (COPYRIGHT "Copyright 2014 Peter Lejeck")
set (DESCRIPTION "GTK3 Client for hummingbird.me")
set (RELEASE_NAME "${DESCRIPTION}")
set (WEBSITE "http://nuckchorris.github.io/nectar/")


# base bits
include (GNUInstallDirs)
set (DATADIR "${CMAKE_INSTALL_FULL_DATAROOTDIR}")
set (PKGDATADIR "${DATADIR}/${CMAKE_PROJECT_NAME}")
set (GETTEXT_PACKAGE "${CMAKE_PROJECT_NAME}")

list (APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
add_definitions ("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")


# niceties
set (CPACK_PACKAGE_VERSION "${VERSION}")
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.git/;/.gitignore/~$;${CPACK_SOURCE_IGNORE_FILES}")

include (CPack)
add_custom_target (dist COMMAND "$CMAKE_MAKE_PROGRAM} package_source")


### PKGCONFIG ###
find_package ( PkgConfig REQUIRED )
pkg_check_modules ( DEPS
	REQUIRED glib-2.0
	REQUIRED gmodule-2.0
	REQUIRED libsoup-2.4
	REQUIRED json-glib-1.0
	REQUIRED gtk+-3.0>=3.10
)
include_directories ( ${DEPS_INCLUDE_DIRS} )
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
add_definitions ( ${DEPS_CFLAGS} )


### GRESOURCES ###
include ( GResource )
set ( GRESOURCES ${CMAKE_CURRENT_SOURCE_DIR}/resources/com.plejeck.nectar.gresource.xml )
glib_compile_resources ( RESOURCE_FILE SOURCE resources/com.plejeck.nectar.gresource.xml )


### VALA FILES ###
find_package ( Vala REQUIRED )
include ( ValaVersion )
ensure_vala_version ( "0.20" MINIMUM )


### Compile ###
configure_file ("${CMAKE_CURRENT_SOURCE_DIR}/src/config.vala.in"
                "${CMAKE_CURRENT_SOURCE_DIR}/src/config.vala")
include ( ValaPrecompile )
vala_precompile (
VALA_C nectar
	src/config.vala
	src/Models/AnimeSeries.vala
	src/Models/User.vala
	src/Backends/Hummingbird.vala
	src/nectar.util.filecache.vala
	src/nectar.util.logger.vala
	src/nectar.util.settings.vala
	src/Widgets/PrefsMenu.vala
	src/Widgets/PrefsBar.vala
	src/Widgets/Image.vala
	src/Widgets/NowPlaying.vala
	src/Widgets/MainPage.vala
	src/Widgets/LoginPage.vala
	src/Widgets/AppWindow.vala
	src/nectar.vala
PACKAGES
	gtk+-3.0
	glib-2.0
	json-glib-1.0
	libsoup-2.4
	gmodule-2.0
	cairo
	posix
OPTIONS
	--thread
	--target-glib=2.38
	--gresources ${GRESOURCES}
)

# Source files definition
set ( SRC_FILES ${RESOURCE_FILE} ${VALA_C} )

add_executable ( nectar ${SRC_FILES} )

target_link_libraries ( nectar ${DEPS_LIBRARIES} m )
