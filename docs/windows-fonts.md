# Obtaining and installing the Windows fonts
- Install p7zip from your distro's package repositories.
- Download the Windows 8.1 Evaluation ISO using [this link](http://download.microsoft.com/download/B/9/9/B999286E-0A47-406D-8B3D-5B5AD7373A4A/9600.17050.WINBLUE_REFRESH.140317-1640_X86FRE_ENTERPRISE_EVAL_EN-US-IR3_CENA_X86FREE_EN-US_DV9.ISO).
- Open a terminal in the folder that the ISO is in and extract the "install.wim" file.
```
7z x 9600.17050.WINBLUE_REFRESH.140317-1640_X86FRE_ENTERPRISE_EVAL_EN-US-IR3_CENA_X86FREE_EN-US_DV9.ISO sources/install.wim
```
- Next, extract the "Fonts" folder from the "install.wim" file.
```
7z x sources/install.wim Windows/Fonts
```
- Delete unnecessary files:
```
rm -rf sources
rm -f Windows/Fonts/*.fon Windows/Fonts/*.ini Windows/Fonts/*.dat Windows/Fonts/*.xml
```
- You should now find the fonts in the "Windows/Fonts" folder. How you install them may vary depending on your distro, but this should work in most cases:
```
sudo cp -r Windows/Fonts /usr/share/fonts/msfonts
fc-cache -f -v
```
You can now delete the ISO as well as the "Windows/Fonts" folder if you want.
