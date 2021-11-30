#!/usr/bin/env playonlinux-bash

# Microsoft 365 Apps / Office 365 install script for PlayOnLinux

#Help me to improve this script and remove unnecessary components

# This software is released under the Zero-Clause BSD licence:
#
# Start of license agreement
#
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#
# End of license agreement

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="Office 365"
SHORTNAME="Office365"
WINEVERSION="cx-21.0.0"
SYSARCH="x86"

# Initial greetings
POL_SetupWindow_Init
POL_Debug_Init
POL_SetupWindow_presentation "$TITLE" "Microsoft" "https://www.office.com" "ETCHDEV" "$SHORTNAME"
wbinfo -V || WINBINDMISSING="yes"
if [ "$WINBINDMISSING" = "yes" ]
then
    POL_SetupWindow_message "$(eval_gettext "Winbind needs to be installed for the Office installer to work. Since winbind doesn't appear to be installed on your system, the PlayOnLinux Wizard will now quit. Please install winbind and then try again. If you can't find it in your distro's package management system, try installing samba, which sometimes contains winbind.")" "$(eval_gettext "Error")"
    POL_SetupWindow_Close
    exit
fi
POL_SetupWindow_message "$(eval_gettext "This script requires Codeweavers' Wine variant in version 21.0.0 and its binaries in my github. The Codeweavers' Wine variant has only the source code, but no binaries. So, you'll have to compile it yourself. Instructions for this are available at https://github.com/DonutsBl/office365-pol/blob/main/docs/build-wine.md but it generally isn't recommended for beginners. This script also assumes that you have all fonts included in the source code.")" "$(eval_gettext "Warning")"

# Let the user select OfficeSetup.exe
POL_SetupWindow_browse "$(eval_gettext "Please select the downloaded installer. You have to use the online installer for the 32-bit version of Microsoft 365 Apps / Office 365.")" "$TITLE"

# Create the Wine prefix
POL_Wine_SelectPrefix "$SHORTNAME"
POL_System_SetArch "$SYSARCH"
POL_Wine_PrefixCreate "$WINEVERSION"
Set_OS "win8"

# Apply registry modifications
POL_System_TmpCreate "$SHORTNAME"
echo 'Windows Registry Editor Version 5.00
[HKEY_CURRENT_USER\Software\Microsoft\Office\ClickToRun\Configuration]
"CDNBaseUrl"="http://officecdn.microsoft.com/pr/7ffbc6bf-bc32-4f92-8982-f9dd17fd3114"
[HKEY_CURRENT_USER\Software\Wine\DllOverrides]
"riched20"="native,builtin"
[HKEY_CURRENT_USER\Software\Wine\EnableUIAutomationCore]
[HKEY_CURRENT_USER\Software\Wine\Mac Driver]
"OpenGLSurfaceMode"="behind"
[HKEY_CURRENT_USER\Software\Wine\MSHTML\MainThreadHack]
[HKEY_CURRENT_USER\Software\Wine\EnableOLEQuitFix]
[HKEY_CURRENT_USER\Software\Wine\Direct2D]
"max_version_factory"=dword:00000000
[HKEY_CURRENT_USER\Software\Wine\X11 Driver]
"ScreenDepth"="32"' > "$POL_System_TmpDir/pre-install.reg"
POL_Wine "regedit.exe" "/c" "$POL_System_TmpDir/pre-install.reg"
POL_System_TmpDelete

# Let the user select Windows 7
POL_SetupWindow_message "$(eval_gettext 'To workaround a problem with Wine, you have to manually select files and select Windows 7 as the emulated Windows version. After clicking "Next", change Windows 8 to Windows 7 in the configuration menu that pops up, and select the two files in directory in the source code then click "OK".')" "$SHORTNAME"
POL_SetupWindow_wait "$(eval_gettext 'Please select Windows 7 and then click "OK".')" "$SHORTNAME"
POL_Wine "winecfg.exe"

# Install prerequisites
POL_Call POL_Install_msxml6
POL_Call POL_Install_vcrun2019
POL_Wine_OverrideDLL "native,builtin" "autorun.exe"
POL_Wine_OverrideDLL "builtin" "ctfmon.exe"
POL_Wine_OverrideDLL "builtin" "ddhelp.exe"
POL_Wine_OverrideDLL "disabled" "docbox.api"
POL_Wine_OverrideDLL "builtin" "findfast.exe"
POL_Wine_OverrideDLL "builtin" "ieinfo5.exe"
POL_Wine_OverrideDLL "builtin" "maildoff.exe"
POL_Wine_OverrideDLL "builtin" "mdm.exe"
POL_Wine_OverrideDLL "builtin" "mosearch.exe"
POL_Wine_OverrideDLL "builtin" "msiexec.exe"
POL_Wine_OverrideDLL "builtin" "pstores.exe"
POL_Wine_OverrideDLL "native,builtin" "user.exe"
POL_Wine_OverrideDLL "native,builtin" "riched20"
POL_Wine_OverrideDLL "native,builtin" "msxml6"
POL_Wine_OverrideDLL "native,builtin" "amstream"
POL_Wine_OverrideDLL "native,builtin" "atl"
POL_Wine_OverrideDLL "native" "concrt140"
POL_Wine_OverrideDLL "native,builtin" "crypt32"
POL_Wine_OverrideDLL "native,builtin" "d3dxof"
POL_Wine_OverrideDLL "native" "dciman32"
POL_Wine_OverrideDLL "native,builtin" "devenum"
POL_Wine_OverrideDLL "native,builtin" "dplay"
POL_Wine_OverrideDLL "native,builtin" "dplaysvr.exe"
POL_Wine_OverrideDLL "native,builtin" "dplayx"
POL_Wine_OverrideDLL "native,builtin" "dpnaddr"
POL_Wine_OverrideDLL "native,builtin" "dpnet"
POL_Wine_OverrideDLL "native,builtin" "dpnhpast"
POL_Wine_OverrideDLL "native,builtin" "dpnhupnp"
POL_Wine_OverrideDLL "native,builtin" "dpnlobby"
POL_Wine_OverrideDLL "native,builtin" "dpnsvr.exe"
POL_Wine_OverrideDLL "native,builtin" "dpnwsock"
POL_Wine_OverrideDLL "native,builtin" "dxdiagn"
POL_Wine_OverrideDLL "native,builtin" "hhctrl.ocx"
POL_Wine_OverrideDLL "native,builtin" "hlink"
POL_Wine_OverrideDLL "native,builtin" "iernonce"
POL_Wine_OverrideDLL "native,builtin" "itss"
POL_Wine_OverrideDLL "native,builtin" "jscript"
POL_Wine_OverrideDLL "native,builtin" "mlang"
POL_Wine_OverrideDLL "native,builtin" "mshtml"
POL_Wine_OverrideDLL "builtin" "msi"
POL_Wine_OverrideDLL "native,builtin" "msvcirt"
POL_Wine_OverrideDLL "native,builtin" "msvcp140"
POL_Wine_OverrideDLL "native,builtin" "msvcrt40"
POL_Wine_OverrideDLL "native,builtin" "msvcrtd"
POL_Wine_OverrideDLL "native,builtin" "odbc32"
POL_Wine_OverrideDLL "native,builtin" "odbccp32"
POL_Wine_OverrideDLL "builtin" "ole32"
POL_Wine_OverrideDLL "builtin" "oleaut32"
POL_Wine_OverrideDLL "builtin" "olepro32"
POL_Wine_OverrideDLL "native,builtin" "quartz"
POL_Wine_OverrideDLL "native,builtin" "riched32"
POL_Wine_OverrideDLL "builtin" "rpcrt4"
POL_Wine_OverrideDLL "native,builtin" "rsabase"
POL_Wine_OverrideDLL "native,builtin" "secur32"
POL_Wine_OverrideDLL "native,builtin" "shdoclc"
POL_Wine_OverrideDLL "native,builtin" "shdocvw"
POL_Wine_OverrideDLL "native,builtin" "softpub"
POL_Wine_OverrideDLL "native,builtin" "urlmon"
POL_Wine_OverrideDLL "builtin" "wininet"
POL_Wine_OverrideDLL "native,builtin" "wintrust"
POL_Wine_OverrideDLL "native,builtin" "wscript.exe"


# Install Office
POL_SetupWindow_wait "$(eval_gettext "Office Setup is running")" "$SHORTNAME"
POL_Wine "$APP_ANSWER"

# Quit the Office setup that doesn't want to close by itself
pkill OfficeC2RClient

POL_SetupWindow_wait "$(eval_gettext "Finishing up...")" "$SHORTNAME"

# Copy missing DLL files
cp "$WINEPREFIX/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/AppvIsvSubsystems32.dll" "$WINEPREFIX/drive_c/Program Files/Microsoft Office/root/Office16/"
cp "$WINEPREFIX/drive_c/Program Files/Common Files/Microsoft Shared/ClickToRun/C2R32.dll" "$WINEPREFIX/drive_c/Program Files/Microsoft Office/root/Office16/"


# Create shortcuts
POL_Shortcut "WINWORD.EXE" "Word" "" "" "Office;WordProcessor;TextEditor;"
POL_Shortcut "EXCEL.EXE" "Excel" "" "" "Office;Spreadsheet;Chart;"
POL_Shortcut "POWERPNT.EXE" "PowerPoint" "" "" "Office;Presentation;"
POL_Shortcut "ONENOTE.EXE" "OneNote" "" "" "Office;"
POL_Shortcut "OUTLOOK.EXE" "Outlook" "" "" "Network;Email;Calendar;ContactManagement;"
POL_Shortcut "MSACCESS.EXE" "Access" "" "" "Ofice;Database;"
POL_Shortcut "MSPUB.EXE" "Publisher" "" "" "Office;Publishing;WordProcessor;"

# Register supported file types
POL_Extension_Write doc "Word"
POL_Extension_Write docm "Word"
POL_Extension_Write docx "Word"
POL_Extension_Write dot "Word"
POL_Extension_Write dotm "Word"
POL_Extension_Write dotx "Word"
POL_Extension_Write odt "Word"
POL_Extension_Write rtf "Word"
POL_Extension_Write wbk "Word"
POL_Extension_Write wiz "Word"
POL_Extension_Write csv "Excel"
POL_Extension_Write dqy "Excel"
POL_Extension_Write iqy "Excel"
POL_Extension_Write odc "Excel"
POL_Extension_Write ods "Excel"
POL_Extension_Write oqy "Excel"
POL_Extension_Write rqy "Excel"
POL_Extension_Write slk "Excel"
POL_Extension_Write xla "Excel"
POL_Extension_Write xlam "Excel"
POL_Extension_Write xlk "Excel"
POL_Extension_Write xll "Excel"
POL_Extension_Write xlm "Excel"
POL_Extension_Write xls "Excel"
POL_Extension_Write xlsb "Excel"
POL_Extension_Write xlshtml "Excel"
POL_Extension_Write xlsm "Excel"
POL_Extension_Write xlsx "Excel"
POL_Extension_Write xlt "Excel"
POL_Extension_Write xlthtml "Excel"
POL_Extension_Write xltm "Excel"
POL_Extension_Write xltx "Excel"
POL_Extension_Write xlw "Excel"
POL_Extension_Write odp "PowerPoint"
POL_Extension_Write pot "PowerPoint"
POL_Extension_Write potm "PowerPoint"
POL_Extension_Write potx "PowerPoint"
POL_Extension_Write ppa "PowerPoint"
POL_Extension_Write ppam "PowerPoint"
POL_Extension_Write pps "PowerPoint"
POL_Extension_Write ppsm "PowerPoint"
POL_Extension_Write ppsx "PowerPoint"
POL_Extension_Write ppt "PowerPoint"
POL_Extension_Write pptm "PowerPoint"
POL_Extension_Write pptx "PowerPoint"
POL_Extension_Write pwz "PowerPoint"
POL_Extension_Write one "OneNote"
POL_Extension_Write onepkg "OneNote"
POL_Extension_Write onetoc "OneNote"
POL_Extension_Write onetoc2 "OneNote"
POL_Extension_Write eml "Outlook"
POL_Extension_Write hol "Outlook"
POL_Extension_Write ics "Outlook"
POL_Extension_Write msg "Outlook"
POL_Extension_Write oft "Outlook"
POL_Extension_Write pst "Outlook"
POL_Extension_Write vcf "Outlook"
POL_Extension_Write vcs "Outlook"
POL_Extension_Write accda "Access"
POL_Extension_Write accdb "Access"
POL_Extension_Write accde "Access"
POL_Extension_Write accdt "Access"
POL_Extension_Write accdw "Access"
POL_Extension_Write mda "Access"
POL_Extension_Write mdb "Access"
POL_Extension_Write mde "Access"
POL_Extension_Write pub "Publisher"

# Done!
POL_SetupWindow_message "$(eval_gettext "Office should be installed now. If you run into significant issues that don't occur under Windows, please report them at https://github.com/ETCHDEV/office365-wine-pol/issues. Or, if they're already reported, you may find a workaround there.")" "$(eval_gettext "Done!")"

POL_SetupWindow_Close
exit
