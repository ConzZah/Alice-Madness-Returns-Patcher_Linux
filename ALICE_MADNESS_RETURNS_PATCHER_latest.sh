#!/usr/bin/env bash
  #=================================================================
  # Project: ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK
  # Author:  ConzZah / ©️ 2024
  # Last Modification: 16.06.2024 / 08:23 [v3.2-1]
  # https://github.com/ConzZah/Alice-Madness-Returns-Patcher_Linux
  #=================================================================
# main
function main {
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
read -n 1 -s; clear
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "  PATCHING ALICE MADNESS RETURNS  "
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""
remove_intro_movies; echo "[ ### EXTRACTING CONFIG FILES ### ]"; cd config_files
install_config_to_my_documents_config && install_config_to_steamapps_config
echo ""; echo "[ ### DONE PATCHING ALICE MADNESS RETURNS ### ]"; echo ""
echo "[ ### CHECKING FOR ALICE 1.. ### ]"
sleep 2; clear; Check4Alice1
}
# remove_intro_movies (literally purges intro movies so you never have to worry about them again.)
function remove_intro_movies {
echo "[ ### REMOVING INTRO MOVIES ### ]"
cd "$intro_movies_path"
rm "Intro_EA.bik" >/dev/null 2>&1; rm "Intro_Nvidia.bik" >/dev/null 2>&1
rm "Intro_SH.bik" >/dev/null 2>&1; rm "TechLogo_Short.bik" >/dev/null 2>&1
cd "$wd"
}
# install_config_to_my_documents_config
function install_config_to_my_documents_config {
echo "[ ### Replacing: AliceEngine.ini ### ]"
7z e documents_config/AliceEngine.ini.7z -y -o"$aliceengineini_path" >/dev/null 2>&1
}
# install_config_to_steamapps_config
function install_config_to_steamapps_config {
echo "[ ### Replacing: DefaultEngine.ini ### ]"
7z e steamapps_config/DefaultEngine.ini.7z -y -o"$defaultengineini_path" >/dev/null 2>&1 
echo "[ ### Replacing: BaseEngine.ini ### ]"
7z e steamapps_config/BaseEngine.ini.7z -y -o"$baseengineini_path" >/dev/null 2>&1 
}
# Check4Alice1
# (checks game directory for existing install of Alice1. if present, the script will ask you if you also want to patch it.)
# (if alice 1 hasn't been found, it will ask you if you want to install it.)
function Check4Alice1 {
exitmsg="HAVE FUN PLAYING :D"
Yes="PROCEEDING.."
if [ ! -d "$alice1_gamepath/bin/base" ]; then echo "[ ~~~ ALICE 1 NOT FOUND ~~~ ]"; echo ""; Ask2install_Alice1; fi
if [ -d "$alice1_gamepath/bin/base" ]; then 
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " ALICE 1 FOUND! WOULD YOU LIKE TO APPLY THE FULLSCREEN PATCH?"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo ""
echo "Y) YES"
echo "N) NO"
echo ""; 
read ask2patch_alice1
case $ask2patch_alice1 in
	Y) echo "$yes"; sleep .5; clear; alice1_fullscreen_fix;;
	y) echo "$yes"; sleep .5; clear; alice1_fullscreen_fix;;
	N) echo "$exitmsg"; sleep 2; exit;;
	n) echo "$exitmsg"; sleep 2; exit;;
	*) clear; Check4Alice1
esac
fi
}
# Ask2install_Alice1 
# (will ask the user if they want to download & install Alice 1 ONLY IF it hasn't been found in the game directory.)
function Ask2install_Alice1 {
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
	Y) echo "$yes"; sleep .5; clear; Alice1_Installer; Check4Alice1;;
	y) echo "$yes"; sleep .5; clear; Alice1_Installer; Check4Alice1;;
	N) echo "$exitmsg"; sleep 2; exit;;
	n) echo "$exitmsg"; sleep 2; exit;;
	*) clear; Ask2install_Alice1
esac
}
# Alice1_Installer (self-explanatory)
function Alice1_Installer {
mkdir -p "$alice1_gamepath"; cd "$alice1_gamepath" && cd ..
rm Alice1.7z >/dev/null 2>&1
echo "~~~~~~~~~~~~~~~~~~~"
echo " Alice 1 Installer"
echo "~~~~~~~~~~~~~~~~~~~"; echo ""
echo "[ ### Downloading Alice1.7z from Archive.org.. ### ]"; echo ""; wget -O Alice1Link.txt https://gist.githubusercontent.com/ConzZah/ffd812046e6a7011b334007b7e8a8037/raw >/dev/null 2>&1 && wget -q --show-progress -i Alice1Link.txt
echo "[ ### Extracting Alice1.7z into Game Directory.. ### ]"; echo ""; 7z x Alice1.7z -y >/dev/null 2>&1
echo "[ ### Cleaning up.. ### ]"; rm Alice1.7z; rm Alice1Link.txt; echo ""
echo "[ ### DONE INSTALLING ALICE 1 ### ]"; echo ""
echo "$exitmsg"
sleep 3
}
# alice1_fullscreen_fix 
# (applies cfg with option [ seta r_fullscreen "1" ] since the default is 0).
# NOTE: This also changes the file permissions of config.cfg to read only.
function alice1_fullscreen_fix {
echo "~~~~~~~~~~~~~~~~~~~~"
echo "  PATCHING ALICE 1  "
echo "~~~~~~~~~~~~~~~~~~~~"; echo ""
mkdir -p "$alice1_cfgpath"; cd "$alice1_cfgpath"; chmod 777 config.cfg >/dev/null 2>&1; cd "$wd"; cd config_files >/dev/null 2>&1
echo "[ ### Extracting config.cfg ### ]"
7z e alice1_config/config.cfg.7z -y -o"$alice1_cfgpath" >/dev/null 2>&1
7z e alice1_config/config.cfg.7z -y -o"$alice1_gamepath/bin/base" >/dev/null 2>&1
echo "[ ### Setting config.cfg to read only ### ]"
cd "$alice1_cfgpath"; chmod 400 config.cfg >/dev/null 2>&1;
echo ""; echo "[ ### DONE PATCHING ALICE 1 ### ]"; echo ""
echo "$exitmsg"; echo ""
echo "[ ~~~ PRESS ANY KEY TO EXIT ~~~ ]"
read -n 1 -s; exit
}
# pre_launch_checks ( loads paths, checks for missing dependencies, etc. )
function pre_launch_checks {
_y="-y"
_doso="sudo"
wd=$(pwd)
hd="/home/$USER"
_install="apt install"
hd_fpak="/home/$USER/.var/app/com.valvesoftware.Steam"
is_alpine=$(uname -v|grep -o -w Alpine); if [[ "$is_alpine" == "Alpine" ]]; then hd=$hd_fpak; _doso="doas"; _install="apk add"; _y=""; fi # <-- sets options for alpine, if detected.
# amr_paths:
steampath="$hd/.local/share/Steam/steamapps/common/Alice Madness Returns"
documentspath="$hd/.steam/steam/steamapps/compatdata/19680/pfx/drive_c/users/steamuser/My Documents/My Games"
intro_movies_path="$steampath/AliceGame/Movies"
defaultengineini_path="$steampath/AliceGame/Config"
baseengineini_path="$steampath/Engine/Config"
aliceengineini_path="$documentspath/Alice Madness Returns/AliceGame/Config"
# alice1_paths:
alice1_gamepath="$steampath/Alice1"
alice1_cfgpath="$documentspath/American McGee's Alice"
################################################################
# if dependencies are missing it will install them before launching
missing_dependency="ERROR MISSING DEPENDENCY:"
prompt="PRESS ANY KEY TO INSTALL"
command -v wget >/dev/null 2>&1 || { echo "$missing_dependency WGET"; echo ""; 
echo "( required for downloading alice 1 )"; echo ""; 
echo "[ ~~~ $prompt WGET ~~~ ]";
read -n 1 -s; $_doso $_install $_y wget; }
command -v 7z >/dev/null 2>&1 || { echo "$missing_dependency 7zip"; echo "";
echo "( required for extracting config files )"; echo ""; 
echo "[ ~~~ $prompt 7zip ~~~ ]";
read -n 1 -s; $_doso $_install $_y 7zip; }
# ( FAILSAFE ) If no config_files folder is found, will get config_files.7z as raw text file from gist link. base64 is used to decode, and 7z to extract.
if [ ! -d config_files ]; then
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " ERROR: NO CONFIG FILES FOUND. GETTING CONFIG FILES..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
wget -O config_files.7z.txt -q https://gist.github.com/ConzZah/e138ebb4ac3f8dd60090ed843a86dece/raw # <-- DOWNLOADS 
base64 -d config_files.7z.txt > config_files.7z # <-- DECODES
7z x config_files.7z >/dev/null 2>&1 # <-- EXTRACTS
rm config_files.7z.txt >/dev/null 2>&1; rm config_files.7z >/dev/null 2>&1; sleep 2; clear; fi # <-- CLEANS UP 
}
clear; pre_launch_checks; main
#     ^ ^ ^ ^ ^ ^ LAUNCH ^ ^ ^ ^ ^ ^
