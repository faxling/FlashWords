TEMPLATE = app

QT += qml quick multimedia svg xml

android: QT += core5compat core-private core

CONFIG += c++14

SOURCES += main.cpp \
    ../harbour-wordquiz/src/crosswordq.cpp \
    ../harbour-wordquiz/src/speechdownloader.cpp \
    ../harbour-wordquiz/src/filehelpers.cpp \
    ../harbour-wordquiz/src/svgdrawing.cpp \
    ../Crossword/crossword.cpp \
    imagepickerandroid.cpp


RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
# QML_IMPORT_PATH =
# Default rules for deployment.
include(deployment.pri)


RC_FILE = ./glosquiz/Resource.rc

HEADERS += \
    ../harbour-wordquiz/src/crosswordq.h \
    ../harbour-wordquiz/src/speechdownloader.h \
    ../harbour-wordquiz/src/filehelpers.h \
    ../harbour-wordquiz/src/svgdrawing.h \
    ../Crossword/crossword.h \
    ./glosquiz/Resource.rc \
    imagepickerandroid.h


DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

ANDROID_EXTRA_LIBS = C:/Users/fraxl/AppData/Local/Android/Sdk/android_openssl/latest/arm64/libcrypto_1_1.so C:/Users/fraxl/AppData/Local/Android/Sdk/android_openssl/latest/arm64/libssl_1_1.so $$PWD/../../../AppData/Local/Android/Sdk/android_openssl/latest/arm/libcrypto_1_1.so $$PWD/../../../AppData/Local/Android/Sdk/android_openssl/latest/arm/libssl_1_1.so



