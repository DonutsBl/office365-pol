#!/usr/bin/env playonlinux-bash

# Microsoft 365 Apps / Office 365 install script for PlayOnLinux
# The newest version of the script, documentation for it and an issue tracker are availabe at https://github.com/DonutsBl/office365-pol
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

TITLE="Microsoft Office 365"
SHORTNAME="Office365"
WINEVERSION="cx-21.2.0"
SYSARCH="x86"

# Initial greetings
POL_SetupWindow_Init
POL_Debug_Init
POL_SetupWindow_presentation "$TITLE" "Microsoft" "https://www.office.com" "DonutsB & ETCHDEV" "$SHORTNAME"
wbinfo -V || WINBINDMISSING="yes"
if [ "$WINBINDMISSING" = "yes" ]
then
    POL_SetupWindow_message "$(eval_gettext "Winbind needs to be installed for the Office installer to work. Since winbind doesn't appear to be installed on your system, the PlayOnLinux Wizard will now quit. Please install winbind and then try again. If you can't find it in your distro's package management system, try installing samba, which sometimes contains winbind.")" "$(eval_gettext "Error")"
    POL_SetupWindow_Close
    exit
fi
POL_SetupWindow_message "$(eval_gettext "This script requires Codeweavers' Wine variant in version 21.2.0, for which you can only get the source code, but no binaries. So, you'll have to compile it yourself. Instructions for this are available at $BLUBBERDUBBER, but it generally isn't recommended for beginners. This script also assumes that you have all fonts that normally ship with Windows 7 or higher installed.")" "$(eval_gettext "Warning")"

# Let the user select OfficeSetup.exe
POL_SetupWindow_browse "$(eval_gettext "Please select the downloaded installer. You have to use the online installer for the 32-bit version of Microsoft Office 365.")" "$TITLE"

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
POL_SetupWindow_message "$(eval_gettext 'To work around a problem with Wine, you have to manually select Windows 7 as the emulated Windows version. After clicking "Next", change Windows 8 to Windows 7 in the configuration menu that pops up, then click "OK".')" "$SHORTNAME"
POL_SetupWindow_wait "$(eval_gettext 'Please select Windows 7 and then click "OK".')" "$SHORTNAME"
POL_Wine "winecfg.exe"

# Install prerequisites
POL_Call POL_Install_msxml6
POL_Call POL_Install_vcrun2019

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
POL_Shortcut "WINWORD.EXE" "Microsoft Word MS365" "" "" "Office;WordProcessor;TextEditor;"
POL_Shortcut "EXCEL.EXE" "Microsoft Excel MS365" "" "" "Office;Spreadsheet;Chart;"
POL_Shortcut "POWERPNT.EXE" "Microsoft PowerPoint MS365" "" "" "Office;Presentation;"
POL_Shortcut "ONENOTE.EXE" "Microsoft OneNote MS365" "" "" "Office;"
POL_Shortcut "OUTLOOK.EXE" "Microsoft Outlook MS365" "" "" "Network;Email;Calendar;ContactManagement;"
POL_Shortcut "MSACCESS.EXE" "Microsoft Access MS365" "" "" "Ofice;Database;"
POL_Shortcut "MSPUB.EXE" "Microsoft Publisher MS365" "" "" "Office;Publishing;WordProcessor;"

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
POL_SetupWindow_message "$(eval_gettext "Microsoft Office should be installed now. If you run into significant issues that don't occur under Windows, please report them at https://github.com/DonutsBl/office365-pol/issues. Or, if they're already reported, you may find a workaround there.")" "$(eval_gettext "Done!")"

POL_SetupWindow_Close
exit
