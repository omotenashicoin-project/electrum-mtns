;--------------------------------
;Include Modern UI
  !include "TextFunc.nsh" ;Needed for the $GetSize function. I know, doesn't sound logical, it isn't.
  !include "MUI2.nsh"
  
;--------------------------------
;Variables

  !define PRODUCT_NAME "electrum-mtns"
  !define PRODUCT_VER "3.3.9"
  !define PRODUCT_WEB_SITE "https://github.com/omotenashicoin-project/electrum-mtns"
  !define PRODUCT_PUBLISHER "omotenashicoin.site"
  !define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}-${PRODUCT_VER}"

;--------------------------------
;General

  ;Name and file
  Name "${PRODUCT_NAME}-${PRODUCT_VER}"
  OutFile "dist/${PRODUCT_NAME}-${PRODUCT_VER}-setup.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}-${PRODUCT_VER}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${PRODUCT_NAME}-${PRODUCT_VER}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

  ;Specifies whether or not the installer will perform a CRC on itself before allowing an install
  CRCCheck on
  
  ;Sets whether or not the details of the install are shown. Can be 'hide' (the default) to hide the details by default, allowing the user to view them, or 'show' to show them by default, or 'nevershow', to prevent the user from ever seeing them.
  ShowInstDetails show
  
  ;Sets whether or not the details of the uninstall  are shown. Can be 'hide' (the default) to hide the details by default, allowing the user to view them, or 'show' to show them by default, or 'nevershow', to prevent the user from ever seeing them.
  ShowUninstDetails show
  
  ;Sets the colors to use for the install info screen (the default is 00FF00 000000. Use the form RRGGBB (in hexadecimal, as in HTML, only minus the leading '#', since # can be used for comments). Note that if "/windows" is specified as the only parameter, the default windows colors will be used.
  InstallColors /windows
  
  ;This command sets the compression algorithm used to compress files/data in the installer. (http://nsis.sourceforge.net/Reference/SetCompressor)
  SetCompressor /SOLID lzma
  
  ;Sets the dictionary size in megabytes (MB) used by the LZMA compressor (default is 8 MB).
  SetCompressorDictSize 64
  
  ;Sets the text that is shown (by default it is 'Nullsoft Install System vX.XX') in the bottom of the install window. Setting this to an empty string ("") uses the default; to set the string to blank, use " " (a space).
  BrandingText "${PRODUCT_NAME} Installer v${PRODUCT_VER}" 
  
  ;Sets what the titlebars of the installer will display. By default, it is 'Name Setup', where Name is specified with the Name command. You can, however, override it with 'MyApp Installer' or whatever. If you specify an empty string (""), the default will be used (you can however specify " " to achieve a blank string)
  Caption "${PRODUCT_NAME}-${PRODUCT_VER}"

  ;Adds the Product Version on top of the Version Tab in the Properties of the file.
  VIProductVersion 1.0.0.0
  
  ;VIAddVersionKey - Adds a field in the Version Tab of the File Properties. This can either be a field provided by the system or a user defined field.
  VIAddVersionKey ProductName "${PRODUCT_NAME} Installer"
  VIAddVersionKey Comments "The installer for ${PRODUCT_NAME}"
  VIAddVersionKey CompanyName "${PRODUCT_PUBLISHER}"
  VIAddVersionKey LegalCopyright "2017-2019 ${PRODUCT_PUBLISHER}"
  VIAddVersionKey FileDescription "${PRODUCT_NAME} Installer"
  VIAddVersionKey FileVersion ${PRODUCT_VER}
  VIAddVersionKey ProductVersion ${PRODUCT_VER}
  VIAddVersionKey InternalName "${PRODUCT_NAME} Installer"
  VIAddVersionKey LegalTrademarks "${PRODUCT_NAME} is a trademark of ${PRODUCT_PUBLISHER}" 
  VIAddVersionKey OriginalFilename "${PRODUCT_NAME}-${PRODUCT_VER}-setup.exe"

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_ABORTWARNING_TEXT "Are you sure you wish to abort the installation of ${PRODUCT_NAME}?"
  
  !define MUI_ICON "c:\electrum\electrum\gui\icons\electrum.ico"
  
;--------------------------------
;Pages

  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

;Check if we have Administrator rights
Function .onInit
	UserInfo::GetAccountType
	pop $0
	${If} $0 != "admin" ;Require admin rights on NT4+
		MessageBox mb_iconstop "Administrator rights required!"
		SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
		Quit
	${EndIf}
FunctionEnd

Section
  SetOutPath $INSTDIR

  ;Files to pack into the installer
  File "dist\${PRODUCT_NAME}-${PRODUCT_VER}.exe"
  File "c:\electrum\electrum\gui\icons\electrum.ico"

  ;Store installation folder
  WriteRegStr HKCU "Software\${PRODUCT_NAME}-${PRODUCT_VER}" "" $INSTDIR

  ;Create uninstaller
  DetailPrint "Creating uninstaller..."
  WriteUninstaller "$INSTDIR\Uninstall.exe"

  ;Create desktop shortcut
  DetailPrint "Creating desktop shortcut..."
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}-${PRODUCT_VER}.lnk" "$INSTDIR\${PRODUCT_NAME}-${PRODUCT_VER}.exe" ""

  ;Create start-menu items
  DetailPrint "Creating start-menu items..."
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}-${PRODUCT_VER}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}-${PRODUCT_VER}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}-${PRODUCT_VER}\${PRODUCT_NAME}-${PRODUCT_VER}.lnk" "$INSTDIR\${PRODUCT_NAME}-${PRODUCT_VER}.exe" "" "$INSTDIR\${PRODUCT_NAME}-${PRODUCT_VER}.exe" 0

  ;Links omotenashicoin: URI's to Electrum-MTNS
  WriteRegStr HKCU "Software\Classes\${PRODUCT_NAME}-${PRODUCT_VER}" "" "URL:omotenashicoin Protocol"
  WriteRegStr HKCU "Software\Classes\${PRODUCT_NAME}-${PRODUCT_VER}" "URL Protocol" ""
  WriteRegStr HKCU "Software\Classes\${PRODUCT_NAME}-${PRODUCT_VER}" "DefaultIcon" "$\"$INSTDIR\electrum.ico, 0$\""
  WriteRegStr HKCU "Software\Classes\${PRODUCT_NAME}-${PRODUCT_VER}\shell\open\command" "" "$\"$INSTDIR\${PRODUCT_NAME}-${PRODUCT_VER}.exe$\" $\"%1$\""

  ;Adds an uninstaller possibilty to Windows Uninstall or change a program section
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VER}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKCU "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\electrum.ico"

  ;Fixes Windows broken size estimates
  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKCU "${PRODUCT_UNINST_KEY}" "EstimatedSize" "$0"
SectionEnd

;--------------------------------
;Descriptions

;--------------------------------
;Uninstaller Section

Section "Uninstall"
  RMDir /r "$INSTDIR\*.*"

  RMDir "$INSTDIR"

  Delete "$DESKTOP\${PRODUCT_NAME}-${PRODUCT_VER}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}-${PRODUCT_VER}\*.*"
  RMDir  "$SMPROGRAMS\${PRODUCT_NAME}-${PRODUCT_VER}"
  
  DeleteRegKey HKCU "Software\Classes\${PRODUCT_NAME}-${PRODUCT_VER}"
  DeleteRegKey HKCU "Software\${PRODUCT_NAME}-${PRODUCT_VER}"
  DeleteRegKey HKCU "${PRODUCT_UNINST_KEY}"
SectionEnd