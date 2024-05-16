#!/bin/bash
  #=================================================================
  # Project: ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK
  # Author:  ConzZah / ©️ 2024
  # Last Modification: 16.05.2024 / 09:32
  # https://github.com/ConzZah/Alice-Madness-Returns-Patcher_Linux
  #=================================================================
# patcher_v2
function patcher_v2 {
echo "          .:*======= ConzZah's =======*:."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo " ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK  "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""
echo "THIS PATCHER ENABLES YOU TO:"; echo "" ; echo ""
echo "- Remove the 30fps lock (Game now runs at min 60 to max 120fps)"; echo ""
echo "- Remove Intro Movies (gets you straight into the game after loading)"; echo ""
echo "- Force-Enable the Weapons of Madness and Dresses Pack DLC"; echo ""
echo "- Optionally Download / Install Alice 1 (from Archive.org), if not installed"; echo ""
echo "- Fix Alice 1 not launching in Fullscreen"; echo "" ; echo ""
echo "  [ ~~~ PRESS ANY KEY TO START PATCHING ~~~ ]"
read -n 1 -s
remove_intro_movies; cd config_files; echo "[ ### EXTRACTING CONFIG FILES ### ]"; echo ""
install_config_to_my_documents_config && install_config_to_steamapps_config && alice1fix && cleanup
echo "[ ### DONE PATCHING ### ]"; echo ""; Check4Alice1
}
# remove_intro_movies
function remove_intro_movies {
clear; echo "[ ### REMOVING INTRO MOVIES ### ]"; echo ""
pushd ~/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/AliceGame/Movies >/dev/null 2>&1
rm "Intro_EA.bik" >/dev/null 2>&1; rm "Intro_Nvidia.bik" >/dev/null 2>&1
rm "Intro_SH.bik" >/dev/null 2>&1; rm "TechLogo_Short.bik" >/dev/null 2>&1
popd >/dev/null 2>&1
}
# install_config_to_my_documents_config
function install_config_to_my_documents_config {
echo "[ ### Replacing: AliceEngine.ini ### ]"; echo
7z e documents_config/Config.7z -y -o/home/$USER/.steam/steam/steamapps/compatdata/19680/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/Alice\ Madness\ Returns/AliceGame/Config >/dev/null 2>&1
}
# install_config_to_steamapps_config
function install_config_to_steamapps_config {
echo "[ ### Replacing: DefaultEngine.ini ### ]"; echo
7z e steamapps_config/Config.7z -y -o/home/$USER/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/AliceGame/Config >/dev/null 2>&1 
}
# alice1fix (applies cfg with option [ seta r_fullscreen "1" ] since the default is 0)
# (NOTE: might find ways to expand this in future versions. feedback is always appreciated.)
function alice1fix {
7z e alice1_config/Config.7z -y -o/home/$USER/.steam/steam/steamapps/compatdata/19680/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/American\ McGee\'s\ Alice/ >/dev/null 2>&1
}
# cleanup (deletes empty Config folders left behind by 7z)
function cleanup {
cd /home/$USER/.steam/steam/steamapps/compatdata/19680/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/Alice\ Madness\ Returns/AliceGame/Config; rm -rf Config >/dev/null 2>&1
cd /home/$USER/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/AliceGame/Config; rm -rf Config >/dev/null 2>&1
}
####################
#  done patching   #
####################
# Check4Alice1
# (checks gamedir for existing install of Alice1. if present, the script has nothing more to do.)
function Check4Alice1 {
cd /home/$USER/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/
if [ ! -d Alice1 ]; then echo "[ ~~~ PRESS ANY KEY TO CONTINUE ~~~ ]"; read -n 1 -s; clear; Ask2install_Alice1; fi
if [ -d Alice1 ]; then echo "[ ~~~ PRESS ANY KEY TO EXIT ~~~ ]"; read -n 1 -s; exit; fi
}
# Ask2install_Alice1 
# (will ask the user if they want to download & install Alice 1 ONLY IF it hasn't been found in the game directory.)
function Ask2install_Alice1 {
No="SCRIPT WILL NOW EXIT."
Yes="PROCEEDING WITH DOWNLOAD.."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " DO YOU WANT TO DOWNLOAD & INSTALL ALICE 1? ( American McGee's Alice )"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""; echo ""
echo "Download Size: ~1GB"
echo "Server: Archive.org"
echo "Proceed & Download?"; echo ""
echo "Y) YES"
echo "N) NO"
echo ""; 
read Ask2install_Alice1
case $Ask2install_Alice1 in
	Y) echo "$yes"; clear; Alice1_Installer;;
	y) echo "$yes"; clear; Alice1_Installer;;
	N) echo "$No"; sleep 2; exit;;
	n) echo "$No"; sleep 2; exit;;
	*) clear; Ask2install_Alice1
esac
}
# Alice1_Installer (self-explanatory)
function Alice1_Installer {
cd /home/$USER/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/
echo "~~~~~~~~~~~~~~~~~~~"
echo " Alice 1 Installer"
echo "~~~~~~~~~~~~~~~~~~~"; echo ""
echo "Downloading Alice1.7z from Archive.org.. ( 925mb )"; wget -O Alice1Link.txt https://gist.githubusercontent.com/ConzZah/ffd812046e6a7011b334007b7e8a8037/raw/bd5ae18142ede5b7922af7e474f42cd92734611c/Alice1_Link.txt >/dev/null 2>&1 && wget -q --show-progress -i Alice1Link.txt
echo "Extracting Alice1.7z into Game Directory.."; 7z x Alice1.7z -y >/dev/null 2>&1
echo "Cleaning up.."; rm Alice1.7z; rm Alice1Link.txt; echo ""
echo "[ ### DONE INSTALLING ALICE 1 ### ]"; echo ""
echo "[ ~~~ PRESS ANY KEY TO EXIT ~~~ ]"
read -n 1 -s; exit
}
# pre_launch_checks
function pre_launch_checks {
missing_dependency="ERROR MISSING DEPENDENCY:"
command -v wget >/dev/null 2>&1 || { echo "$missing_dependency WGET"; echo ""; 
echo "( required for downloading alice 1 )"; echo ""; 
echo "[ ~~~ PRESS ANY KEY TO INSTALL WGET ~~~ ]";
read -n 1 -s; sudo apt install wget; }
# ( FAILSAFE ) If no config_files folder is found, will get config_files.7z as raw text file from gist link. base64 is used to decode, and 7z to extract.
if [ ! -d config_files ]; then
wget -O config_files.7z.txt -q https://gist.githubusercontent.com/ConzZah/4c4905e6ddeef2254067cc9bca6963be/raw/3ae52c42d61eb3db28c9a61acbbf7d0222c0af12/encoded_base64__config_files_v2.7z.txt # <-- DOWNLOADS 
base64 -d config_files.7z.txt > config_files.7z # <-- DECODES
7z x config_files.7z >/dev/null 2>&1 # <-- EXTRACTS
rm config_files.7z.txt >/dev/null 2>&1; rm config_files.7z >/dev/null 2>&1; fi # <-- CLEANS UP 
}
clear; pre_launch_checks; patcher_v2
#     ^ ^ ^ ^ ^ ^ LAUNCH ^ ^ ^ ^ ^ ^
