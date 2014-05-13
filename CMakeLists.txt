### BOILERPLATE ###
cmake_minimum_required ( VERSION 2.8 )
list ( APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake )
set ( CMAKE_INCLUDE_CURRENT_DIR ON )
set ( CMAKE_COLOR_MAKEFILE ON )

string ( COMPARE EQUAL "${CMAKE_SOURCE_DIR}" "${CMAKE_BINARY_DIR}" insource )
if ( insource )
	message ( FATAL_ERROR "Nectar requires an out-of-source build." )
endif ( insource )

### PROJECT INFO ###
project ( Undesktop-AskPass C )
set ( VERSION "0.1.0" )
set ( COPYRIGHT "Copyright 2014 Peter Lejeck" )
set ( DESCRIPTION "GTK3 client for Hummingbird.me" )
set ( WEBSITE "http://nuckchorris.github.io/nectar/" )


### PKGCONFIG ###
find_package ( PkgConfig REQUIRED )
pkg_check_modules ( DEPS
	REQUIRED glib-2.0
	REQUIRED gmodule-2.0
	REQUIRED libsoup-2.4
	REQUIRED gtk+-3.0>=3.10
)
include_directories ( ${DEPS_INCLUDE_DIRS} )
link_libraries ( ${DEPS_LIBRARIES} )
link_directories ( ${DEPS_LIBRARY_DIRS} )
add_definitions ( ${DEPS_CFLAGS} )


### VALA FILES ###
find_package ( Vala REQUIRED )
include ( ValaVersion )
ensure_vala_version ( "0.20" MINIMUM )


### Compile ###
include ( ValaPrecompile )
vala_precompile (
VALA_C nectar
	src/nectar.widget.webimage.vala
	src/nectar.widget.nowplaying.vala
	src/nectar.vala
PACKAGES
	gtk+-3.0
	glib-2.0
	libsoup-2.4
	gmodule-2.0
	cairo
	posix
OPTIONS
	--thread
	--target-glib=2.38
)

# Source files definition
set ( SRC_FILES ${RESOURCE_FILE} ${VALA_C} )

add_executable ( nectar ${SRC_FILES} )

target_link_libraries ( nectar ${DEPS_LIBRARIES} m )
