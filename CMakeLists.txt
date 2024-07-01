cmake_minimum_required(VERSION 3.16)

project(FlashWords VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick Multimedia Svg Xml)

qt_standard_project_setup()



if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    enable_language("RC")
    set (WIN32_RESOURCES Resource.rc)
endif()

qt_add_executable(FlashWords
    main.cpp
    imagepickerandroid.cpp
    ../harbour-wordquiz/src/crosswordq.cpp
    ../harbour-wordquiz/src/Filehelpers.cpp
    ../harbour-wordquiz/src/speechdownloader.cpp
    ../harbour-wordquiz/src/svgdrawing.cpp
    ../harbour-wordquiz/src/svgdrawing.cpp
    ../Crossword/crossword.cpp
    qml.qrc
    ${WIN32_RESOURCES}
)

qt_add_qml_module(
    FlashWords
    RESOURCE_PREFIX :/
    URI FlashWords
    VERSION 1.0
    QML_FILES
    RESOURCES qml.qrc

)



set_target_properties(FlashWords PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appFlashWords
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(FlashWords
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::Multimedia
    PRIVATE Qt6::Svg
    PRIVATE Qt6::Xml
)


include(GNUInstallDirs)
install(TARGETS FlashWords
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
