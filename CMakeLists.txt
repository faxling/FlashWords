cmake_minimum_required(VERSION 3.20)

project(FlashWords VERSION 1.0 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)
set(QT_ANDROID_TARGET_SDK_VERSION 36)

find_package(Qt6 REQUIRED COMPONENTS Core CorePrivate Quick Multimedia Svg Xml Qml Sql WebView)

qt_standard_project_setup()

if (${CMAKE_SYSTEM_NAME} MATCHES "Windows")
    enable_language("RC")
    set (WIN32_RESOURCES Resource.rc)
endif()

set(HEADERS
    ../harbour-wordquiz/src/crosswordq.h
    ../harbour-wordquiz/src/Filehelpers.h
    ../harbour-wordquiz/src/speechdownloader.h
    ../harbour-wordquiz/src/svgdrawing.h)

qt_add_executable(FlashWords
    main.cpp
    ../harbour-wordquiz/src/crosswordq.cpp
    ../harbour-wordquiz/src/Filehelpers.cpp
    ../harbour-wordquiz/src/speechdownloader.cpp
    ../harbour-wordquiz/src/svgdrawing.cpp
    ../Crossword/crossword.cpp
    qml.qrc
    ${HEADERS}
    ${WIN32_RESOURCES}
)



qt_add_qml_module(
    FlashWords
    RESOURCE_PREFIX :/
    URI FlashWords
    VERSION 1.0
    QML_FILES
    RESOURCES qml.qrc
    RESOURCES android/AndroidManifest.xml
)



set_target_properties(FlashWords PROPERTIES
    WIN32_EXECUTABLE TRUE
)



target_link_libraries(FlashWords
    PRIVATE Qt6::Sql
    PRIVATE Qt6::Quick
    PRIVATE Qt6::Core
    PRIVATE Qt6::CorePrivate
    PRIVATE Qt6::Multimedia
    PRIVATE Qt6::Svg
    PRIVATE Qt6::Xml
    PRIVATE Qt6::WebView
    PRIVATE Qt6::Qml
)

set_property(TARGET FlashWords APPEND PROPERTY
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/android
)

if (ANDROID)
    include(FetchContent)
    FetchContent_Declare(
        android_openssl
        DOWNLOAD_EXTRACT_TIMESTAMP true
        URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
    )
    FetchContent_MakeAvailable(android_openssl)
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
endif()

if (ANDROID)
    add_android_openssl_libraries(FlashWords)
endif()



include(GNUInstallDirs)

install(TARGETS FlashWords
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

message(STATUS "android ndk=${CMAKE_ANDROID_NDK_VERSION}")
message(STATUS "version=${PROJECT_NAME} ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR} libname=${INSERT_APP_LIB_NAME}")
message(STATUS "android arc=${CMAKE_PREFIX_PATH}")


if (ANDROID)


endif()




#qt_android_generate_deployment_settings(FlashWords)


