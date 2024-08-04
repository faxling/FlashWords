
; NSIS Modern User Interface
!define VERSION 1.0.0.1

VIAddVersionKey "ProductName" "FlashWord"
VIAddVersionKey "Comments" "FlashWords"
VIAddVersionKey "CompanyName" "SoftAx"
VIAddVersionKey "LegalTrademarks" "Soft Ax"
VIAddVersionKey "LegalCopyright" "©Soft Ax"
VIAddVersionKey "FileDescription" "FlashWords"
VIAddVersionKey "FileVersion" "${VERSION}"
VIAddVersionKey "ProductVersion" "${VERSION}"
VIProductVersion ${VERSION}
VIAddVersionKey "PrivateBuild" "${VERSION} ${__DATE__} ${__TIME__}"
; Include Modern UI
!include "MUI2.nsh"

; General

  ; Name and output file
  Name "FlashWords"
  OutFile "FlashWords_${VERSION}.exe"

  ; Default installation folder
  InstallDir "$LOCALAPPDATA\FlashWords"
  
  ; Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\FlashWords" ""

  ; Request application privileges for Windows Vista/7/8/10
  RequestExecutionLevel user

; --------------------------------
; Interface Settings

; --------------------------------
; Pages

!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_WELCOMEPAGE_TEXT "FlashWords ${VERSION}"
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
  
; --------------------------------
; Languages
 
  !insertmacro MUI_LANGUAGE "English"

; --------------------------------
; Installer Sections


; use tool windeployqt.exe C:/Users/fraxl/Documents/qt/build-FlashWords-Desktop_Qt_6_5_3_MinGW_64_bit-Release/FlashWords.exe --qmldir c:\Users\fraxl\Documents\qt\FlashWords -dir c:\Qt515\6.5.3\Deploy_mingw\bin
; to generate install files

Section "WordQuiz" SecDummy

  SetOutPath "$INSTDIR"

  File /r c:\Qt515\6.5.3\Deploy_mingw\bin

  SetOutPath "$INSTDIR\Bin"

  File C:\Users\fraxl\Documents\qt\build-FlashWords-Desktop_Qt_6_5_3_MinGW_64_bit-Release\FlashWords.exe
 
 
  CreateShortCut "$SMPROGRAMS\FlashWords.lnk" "$INSTDIR\bin\FlashWords.exe" 
  CreateShortCut "$DESKTOP\FlashWords.lnk" "$INSTDIR\bin\FlashWords.exe"
   
  ; Store installation folder
  WriteRegStr HKCU "Software\FlashWords" "" $INSTDIR

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

; Uninstaller Section

Section "Uninstall"

  RMDir /r /REBOOTOK "$LOCALAPPDATA\FlashWords"

  DeleteRegKey /ifempty HKCU "Software\FlashWords"
  Delete "$DESKTOP\FlashWords.lnk"


SectionEnd
