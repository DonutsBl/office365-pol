# Building winecx using Docker
## Installing Docker
The exact way to do this will vary depending on your distro.
- For Arch users (or users of Arch derivates):
'''
sudo pacman -Sy --needed docker
'''
- Debian users (or users of Debian derivates) can either install the version from the distribution's repositories, which may be somewhat out of date:
'''
sudo apt update && sudo apt install docker
'''
Or they can use the official Docker install script:
'''
wget -O install.sh https://get.docker.com && sudo sh install.sh && rm install.sh
'''
If you're using a distro that's not listed here, you'll have to find instructions for installing Docker somewhere else.
- After the installation, make sure Docker is started:
'''
sudo systemctl start docker
'''
You can probably also use Podman instead of Docker, but I haven't tested this.
## Preparing some files
- Create a folder somewhere and change to it:
'''
mkdir winebuild
cd winebuild
'''
- Download the Dockerfile for the winebuild container:
'''
wget -O Dockerfile https://raw.githubusercontent.com/PhoenicisOrg/phoenicis-winebuild/cf86dd3c98ba0b8fdbd5f9fc02bc5a4c15587ee9/environments/linux-x86-wine
'''
## Setting up the compiling environment
- Build the Docker container image:
'''
sudo docker build .
'''
- Depending on your internet connection and your PC, this can take a while. When it finishes, you should see something like
'''
Successfully built 389d48e71218
'''
- Take note of the ID at the end of the message (which won't be the one I got). Using this ID, you can start a container:
'''
sudo docker run -it -v $(realpath ./build):/mnt/build --name winebuild your-id-here
'''
- You'll get a shell running inside the container. This container has a volume set up up, which causes everything you write to its /mnt/build directory to end up in a "build" subdirectory of your "winebuild" directory. With this in mind, we're going to store everything important to /mnt/build while working with the container. So, change to /mnt/build and then download and extract the source code we'll be compiling:
'''
cd /mnt/build
wget https://media.codeweavers.com/pub/crossover/source/crossover-sources-20.0.4.tar.gz
tar -xzf crossover-sources-20.0.4.tar.gz sources/wine
'''
## Compiling
- Change into the extracted directory:
'''
cd sources/wine
'''
- Create distversion.h since it's missing from the source code package for some reason:
'''
echo '#define WINDEBUG_WHAT_HAPPENED_MESSAGE "This can be caused by a problem in the program or a deficiency in Wine."' >> include/distversion.h
echo '#define WINDEBUG_USER_SUGGESTION_MESSAGE "If this problem is not present under Windows and has not been reported yet, you can save the detailed information to a file using the \"Save As\" button, then file a bug report and attach that file to the report."' >> include/distversion.h
'''
- Run the configuration script:
'''
./configure --disable-winedbg --disable-mscms --without-vulkan
'''
- Start compiling:
'''
make
'''
- This will (once again) take quite a while. Once it finishes, you should see:
'''
Wine build complete.
'''
## Collecting some files
- Install Wine inside the container:
'''
make install
'''
- Create a folder in /mnt/build that all the compiled Wine files will be copied into:
'''
mkdir /mnt/build/cx-20.0.4
'''
- Copy the files:
'''
cp -R /usr/local/bin /mnt/build/sources/wine/include /mnt/build/cx-20.0.4
mkdir /mnt/build/cx-20.0.4/lib
cp -R /usr/local/lib/wine /usr/local/lib/libwine* /mnt/build/cx-20.0.4/lib
mkdir /mnt/build/cx-20.0.4/share
cp -R /usr/local/share/man /usr/local/share/wine /mnt/build/cx-20.0.4/share
'''
## Finishing up
- Exit out of the container:
'''
exit
'''
- Make sure PlayOnLinux has been started at least once, then copy the "cx-20.0.4" folder to the PlayOnLinux "wine" folder:
'''
cp -R build/cx-20.0.4 ~/.PlayOnLinux/wine/
'''
And with that, you're build of Wine is ready to be used in PlayOnLinux.
- Once you've verified hte build works, you can delete the "build" directory:
'''
sudo rm -rf build
'''
- You can also check the ID for your container (not the container image ID!):
'''
sudo docker ps --all
'''
Search for the "winebuild" container in the list and take note of the container ID, which will allow you to delete the container:
sudo docker rm -v your-container-id-here
- If you're sure you will never need to do this again, you can also delete the container image as well the entire "winebuild" directory:
'''
sudo docker rmi your-image-id-here
cd ..
sudo rm -rf winebuild
'''