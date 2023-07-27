# THIS IS OUTDATED
This project is mostly abandoned, it does not and likely will never work with current versions of MS365. It was made when Microsoft still provided a Windows 7 release of Office 365, which was considerabely easier to get working. Current versions only support Windows 10 and 11 and use components exclusive to those operating systems that Wine currently does not support in any way, such as UWP libraries. At the moment, I believe no one has gotten them working.

## What now?
The script from this project might still work, but if it does, it will install a very outdated version of Office 365, which should be considered a significant security risk. Since I believe it should no longer be used, I will also no longer be fixing bugs. Most people should probably switch to a natively supported office suite like LibreOffice (free and open source) or SoftMaker Office (commercial, proprietary), which have fairly solid Microsoft Office comatibility. If you absolutely need Microsoft Office, you'll have to either use Office 2016, which can be run with Wine and will receive security updates until October 2025, or use a virtual machine, which will allow you to use the latest versions, but isn't as convenient and also requires a Windows license.

# Original readme
## office365-pol
An experimental PlayOnLinux script that utilizes the version of Wine made for CrossOver to run Microsoft 365 Apps / Office 365 on Linux-based systems without requiring any paid CrossOver components

## Fair warning
At his point in time, this script is not recommended for beginner users since it requires you to manually compile the CrossOver version of Wine (also known as winecx). The method explained [here](https://github.com/DonutsBl/office365-pol/blob/main/docs/build-wine.md) utilizes Docker to create a clean compiling environment, so it really should work every time. But it's still a fairly complicated process with a lot of command prompt wizardry involved.

## Installation guide
- Install PlayOnLinux (obviously) as well as winbind, which is required for the Office installer to work. If you can't find  (a decently recent version of) PlayOnLinux in your distribution's package repositories, you can visit [the official PlayOnLinux website](https://www.playonlinux.com/en/download.html) for installation instrucions. If you can't find winbind, try installing samba, which sometimes contains winbind.
- Compile and install winecx according to the instructions [here](https://github.com/DonutsBl/office365-pol/blob/main/docs/build-wine.md).
- Install the Windows fonts if you haven't done this yet. Note that you'll need fonts that typically don't come with the "Microsoft corefonts" packages that some Linux distributions offer. There's a guide on installing all fonts that ship with Windows [here](https://github.com/DonutsBl/office365-pol/blob/main/docs/windows-fonts.md).
- Download the Microsoft 365 Apps / Office 365 setup. Note that the offline installer won't work, as it currently requires at least Windows 8.1, while this script only works while emulating Windows 7. The 64-bit version is not compatible either. To download the 32-bit online installer, go to https://portal.office.com/account/?ref=MeControl, log in with the account that your Office license is linked to, then click on "View apps & devices". Now, you should see the options for downloading Office, but you probably won't, as they only display when using Windows to visit the website. So, you'll either have to use a Windows device for the download or change your user agent to pretend you're using Windows. Once you can see the options, select the 32-bit version, then select the language you want and click on the "Install Office" button to start the download.
- Download the installation script from https://raw.githubusercontent.com/DonutsBl/office365-pol/main/office365-pol.sh by right-clicking the link and then choosing the "save as" option.
- Open up PlayOnLinux, choose Tools | Run a local script, select the script you downloaded and get past the warnings regarding the script not being authorized by the PlayOnLinux team. After that, the script should start and you can follow its instructions.

## License
Unless otherwise specified, everything in this repository is licensed under the [Zero-Clause BSD license](https://github.com/DonutsBl/office365-pol/blob/main/LICENSE). This does not necessarily apply to dependencies which are needed to use this software, but not contained in its repository.
