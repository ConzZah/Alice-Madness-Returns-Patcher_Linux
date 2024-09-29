#!/usr/bin/env bash
  #=================================================================
  # Project: ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK
  # Author:  ConzZah / ©️ 2024
  # Last Modification: 29.09.2024 / 17:04 [v3.4]
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
remove_intro_movies; install_config_to_my_documents_config; install_config_to_steamapps_config
echo ""; echo "[ ### DONE PATCHING ALICE MADNESS RETURNS ### ]"; echo ""; echo "[ --> CHECKING FOR ALICE 1.. ]"; echo ""; sleep 2; Check4Alice1 ;}
# remove_intro_movies (literally purges intro movies so you never have to worry about them again.)
function remove_intro_movies { echo "[ --> REMOVING: INTRO MOVIES ]"; cd "$intro_movies_path"; rm "Intro_EA.bik" "Intro_Nvidia.bik" "Intro_SH.bik" "TechLogo_Short.bik" >/dev/null 2>&1; cd "$wd/config_files" ;}
# install_config_to_my_documents_config
function install_config_to_my_documents_config { echo "[ --> EXTRACTING: AliceEngine.ini ]"; 7z e documents_config/AliceEngine.ini.7z -y -o"$aliceengineini_path" >/dev/null 2>&1 ;}
# install_config_to_steamapps_config
function install_config_to_steamapps_config {
echo "[ --> EXTRACTING: DefaultEngine.ini ]"; 7z e steamapps_config/DefaultEngine.ini.7z -y -o"$defaultengineini_path" >/dev/null 2>&1 
echo "[ --> EXTRACTING: BaseEngine.ini ]"; 7z e steamapps_config/BaseEngine.ini.7z -y -o"$baseengineini_path" >/dev/null 2>&1 ;}
# Check4Alice1 <-- (checks game directory for existing install of Alice1. if present, call alice1_fullscreen_fix, if not, call Ask2install_Alice1 )
function Check4Alice1 { [ ! -f "$alice1_gamepath/bin/alice.exe" ] && Ask2install_Alice1 || [ -f "$alice1_gamepath/bin/alice.exe" ] && alice1_fullscreen_fix ;}
# Ask2install_Alice1 
function Ask2install_Alice1 { clear; echo "[ ~~~ ALICE 1 NOT FOUND ~~~ ]"; echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " DO YOU WANT TO DOWNLOAD & INSTALL ALICE 1? ( American McGee's Alice )"
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""; echo ""
echo "Download Size: ~1GB"
echo "Server: Archive.org"
echo "Proceed & Download?"; echo ""
echo "Y) YES"; echo "N) NO"; echo ""; 
read Ask2install_Alice1
case $Ask2install_Alice1 in
	y|Y) clear; Alice1_Installer;;
	n|N) echo "$_done"; quit;;
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
echo "[ --> Downloading Alice1.7z from Archive.org ]"; echo ""; $curl Alice1.7z https://archive.org/download/alice1_202405/Alice1.7z; echo ""
echo "[ --> Extracting Alice1.7z ]"; echo ""; 7z x Alice1.7z -y >/dev/null 2>&1
echo "[ --> Cleaning up.. ]"; rm Alice1.7z; echo ""; echo "[ ### DONE INSTALLING ALICE 1 ### ]"; echo ""
alice1_fullscreen_fix
}
# alice1_fullscreen_fix 
# (applies default_pc.cfg with option seta r_fullscreen "1" since the default is 0).
function alice1_fullscreen_fix { echo "[ ~~~ ALICE 1 FOUND ~~~ ]"; echo ""
echo "~~~~~~~~~~~~~~~~~~~~"
echo "  PATCHING ALICE 1  "
echo "~~~~~~~~~~~~~~~~~~~~"; echo ""
mkdir -p "$alice1_cfgpath"; chmod 644 "$alice1_cfgpath/config.cfg" >/dev/null 2>&1; cd "$wd/config_files";
echo "[ --> EXTRACTING: config.cfg ]"; 7z e alice1_config/config.cfg.7z -y -o"$alice1_cfgpath" >/dev/null 2>&1
echo "[ --> EXTRACTING: default_pc.cfg ]"; 7z e alice1_config/default_pc.cfg.7z -y -o"$alice1_gamepath/bin/base" >/dev/null 2>&1
echo ""; echo "[ ### DONE PATCHING ALICE 1 ### ]"; echo ""; echo "$_done"; quit ;}
# quit 
function quit { echo ""; echo "[ ~~~ PRESS ANY KEY TO EXIT ~~~ ]"; read -n 1 -s; exit ;}
# pre_launch_checks ( loads paths, checks for missing dependencies, etc. )
function pre_launch_checks {
_doso="sudo"
wd=$(pwd)
curl="curl -# -L -o"
_done="HAVE FUN PLAYING :D"
hd="/home/$USER"
hd_fpak="/home/$USER/.var/app/com.valvesoftware.Steam"
check4fpak=$(flatpak list|grep -o Steam|head -n 1)
[ ! -z "$check4fpak" ] && [ -d "$hd_fpak" ] && hd="$hd_fpak" # <-- if steam flatpak and the corresponding dir exist, set $hd to $hd_fpak
# detect package manager:
i=0; bin=("apt" "apk" "dnf" "yum" "pacman" "zypper" "brew"); pm=""
while [ $i -lt ${#bin[@]} ]; do
if type -p "${bin[$i]}" > /dev/null; then pm="${bin[$i]}"; _install="$pm install"; break; fi
((i++))
done
if [[ "$pm" == "apk" ]]; then _install="apk add"; _doso="doas"; fi; 
if [[ "$pm" == "pacman" ]]; then _install="pacman -S"; fi
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
# ( FAILSAFE ) If main executable doesn't exist, don't launch.
[ ! -f "$steampath/Binaries/Win32/AliceMadnessReturns.exe" ] && echo "ERROR: ALICE MADNESS RETURNS COULD NOT BE FOUND" && quit
# ( FAILSAFE ) If curl or 7zip are missing, install them before launching
! type -p curl >/dev/null && $_doso $_install curl; ! type -p 7z >/dev/null && $_doso $_install 7zip
# ( FAILSAFE ) If no config_files folder is found, will get config_files.7z as raw text file from gist link. base64 is used to decode, and 7z to extract.
if [ ! -d "$wd/config_files" ]; then
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo " ERROR: NO CONFIG FILES FOUND. GETTING CONFIG FILES..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""
$curl config_files.7z.txt https://gist.github.com/ConzZah/e138ebb4ac3f8dd60090ed843a86dece/raw # <-- DOWNLOADS 
base64 -d config_files.7z.txt > config_files.7z # <-- DECODES
7z x config_files.7z >/dev/null 2>&1 # <-- EXTRACTS
sleep 2; rm config_files.7z.txt config_files.7z >/dev/null 2>&1; clear; fi # <-- CLEANS UP 
}
clear; pre_launch_checks; main # <-- launch
