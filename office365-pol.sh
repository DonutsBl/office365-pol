#!/usr/bin/env playonlinux-bash

# Microsoft 365 Apps / Office 365 install script for PlayOnLinux
# Version 1.0, developed by DonutsB, released in June 2021
# Tested with PlayOnLinux 4.3.4 on Manjaro Linux version 21.0.7
# The newest version of the script, documentation for it and an issue tracker are availabe at https://github.com/DonutsBl/office365-pol/issues
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

TITLE="Microsoft 365 Apps / Office 365"
SHORTNAME="Office365"
WINEVERSION="cx-20.0.4"
SYSARCH="x86"

# Initial greetings
POL_SetupWindow_Init
POL_Debug_Init
POL_SetupWindow_presentation "$TITLE" "Microsoft" "https://www.office.com" "DonutsB" "$SHORTNAME"
wbinfo -V || WINBINDMISSING="yes"
if [ "$WINBINDMISSING" = "yes" ]
then
    POL_SetupWindow_message "$(eval_gettext "Winbind needs to be installed for the Office installer to work. Since winbind doesn't appear to be installed on your system, the PlayOnLinux Wizard will now quit. Please install winbind and then try again. If you can't find it in your distro's package management system, try installing samba, which sometimes contains winbind.")" "$(eval_gettext "Error")"
    POL_SetupWindow_Close
    exit
fi
POL_SetupWindow_message "$(eval_gettext "This script requires Codeweavers' Wine variant in version 20.0.4, for which you can only get the source code, but no binaries. So, you'll have to compile it yourself. Instructions for this are available at $BLUBBERDUBBER, but it generally isn't recommended for beginners. This script also assumes that you have all fonts that normally ship with Windows 7 or higher installed.")" "$(eval_gettext "Warning")"

# Let the user select OfficeSetup.exe
POL_SetupWindow_browse "$(eval_gettext "Please select the downloaded installer. You have to use the online (!) installer for the 32-bit (!) version of Microsoft 365 Apps / Office 365.")" "$TITLE"

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
POL_Extension_Write doc "Microsoft Word MS365"
POL_Extension_Write docm "Microsoft Word MS365"
POL_Extension_Write docx "Microsoft Word MS365"
POL_Extension_Write dot "Microsoft Word MS365"
POL_Extension_Write dotm "Microsoft Word MS365"
POL_Extension_Write dotx "Microsoft Word MS365"
POL_Extension_Write odt "Microsoft Word MS365"
POL_Extension_Write rtf "Microsoft Word MS365"
POL_Extension_Write wbk "Microsoft Word MS365"
POL_Extension_Write wiz "Microsoft Word MS365"
POL_Extension_Write csv "Microsoft Excel MS365"
POL_Extension_Write dqy "Microsoft Excel MS365"
POL_Extension_Write iqy "Microsoft Excel MS365"
POL_Extension_Write odc "Microsoft Excel MS365"
POL_Extension_Write ods "Microsoft Excel MS365"
POL_Extension_Write oqy "Microsoft Excel MS365"
POL_Extension_Write rqy "Microsoft Excel MS365"
POL_Extension_Write slk "Microsoft Excel MS365"
POL_Extension_Write xla "Microsoft Excel MS365"
POL_Extension_Write xlam "Microsoft Excel MS365"
POL_Extension_Write xlk "Microsoft Excel MS365"
POL_Extension_Write xll "Microsoft Excel MS365"
POL_Extension_Write xlm "Microsoft Excel MS365"
POL_Extension_Write xls "Microsoft Excel MS365"
POL_Extension_Write xlsb "Microsoft Excel MS365"
POL_Extension_Write xlshtml "Microsoft Excel MS365"
POL_Extension_Write xlsm "Microsoft Excel MS365"
POL_Extension_Write xlsx "Microsoft Excel MS365"
POL_Extension_Write xlt "Microsoft Excel MS365"
POL_Extension_Write xlthtml "Microsoft Excel MS365"
POL_Extension_Write xltm "Microsoft Excel MS365"
POL_Extension_Write xltx "Microsoft Excel MS365"
POL_Extension_Write xlw "Microsoft Excel MS365"
POL_Extension_Write odp "Microsoft PowerPoint MS365"
POL_Extension_Write pot "Microsoft PowerPoint MS365"
POL_Extension_Write potm "Microsoft PowerPoint MS365"
POL_Extension_Write potx "Microsoft PowerPoint MS365"
POL_Extension_Write ppa "Microsoft PowerPoint MS365"
POL_Extension_Write ppam "Microsoft PowerPoint MS365"
POL_Extension_Write pps "Microsoft PowerPoint MS365"
POL_Extension_Write ppsm "Microsoft PowerPoint MS365"
POL_Extension_Write ppsx "Microsoft PowerPoint MS365"
POL_Extension_Write ppt "Microsoft PowerPoint MS365"
POL_Extension_Write pptm "Microsoft PowerPoint MS365"
POL_Extension_Write pptx "Microsoft PowerPoint MS365"
POL_Extension_Write pwz "Microsoft PowerPoint MS365"
POL_Extension_Write one "Microsoft OneNote MS365"
POL_Extension_Write onepkg "Microsoft OneNote MS365"
POL_Extension_Write onetoc "Microsoft OneNote MS365"
POL_Extension_Write onetoc2 "Microsoft OneNote MS365"
POL_Extension_Write eml "Microsoft Outlook MS365"
POL_Extension_Write hol "Microsoft Outlook MS365"
POL_Extension_Write ics "Microsoft Outlook MS365"
POL_Extension_Write msg "Microsoft Outlook MS365"
POL_Extension_Write oft "Microsoft Outlook MS365"
POL_Extension_Write pst "Microsoft Outlook MS365"
POL_Extension_Write vcf "Microsoft Outlook MS365"
POL_Extension_Write vcs "Microsoft Outlook MS365"
POL_Extension_Write accda "Microsoft Access MS365"
POL_Extension_Write accdb "Microsoft Access MS365"
POL_Extension_Write accde "Microsoft Access MS365"
POL_Extension_Write accdt "Microsoft Access MS365"
POL_Extension_Write accdw "Microsoft Access MS365"
POL_Extension_Write mda "Microsoft Access MS365"
POL_Extension_Write mdb "Microsoft Access MS365"
POL_Extension_Write mde "Microsoft Access MS365"
POL_Extension_Write pub "Microsoft Publisher MS365"

# Done!
POL_SetupWindow_message "$(eval_gettext "Microsoft Office should be installed now. If you run into significant issues that don't occur under Windows, please report them at https://github.com/DonutsBl/office365-pol/issues. Or, if they're already reported, you may find a workaround there.")" "$(eval_gettext "Done!")"

POL_SetupWindow_Close
exit
