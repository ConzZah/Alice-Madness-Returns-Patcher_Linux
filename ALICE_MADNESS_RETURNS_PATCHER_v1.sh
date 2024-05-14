#!/bin/bash
  #=================================================================
  # Project: ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK
  # Author:  ConzZah / ©️ 2024
  # Last Modification: 14.05.2024 / 07:27
  # https://github.com/ConzZah/Alice-Madness-Returns-Patcher-Linux
  #=================================================================
# remove_intro_movies
function remove_intro_movies {
pushd ~/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/AliceGame/Movies >/dev/null 2>&1
rm "Intro_EA.bik" >/dev/null 2>&1; rm "Intro_Nvidia.bik" >/dev/null 2>&1; rm "Intro_SH.bik" >/dev/null 2>&1; popd >/dev/null 2>&1
}
# install_config_to_my_documents_config
function install_config_to_my_documents_config {
7z e documents_config/Config.7z -y -o/home/$USER/.steam/steam/steamapps/compatdata/19680/pfx/drive_c/users/steamuser/My\ Documents/My\ Games/Alice\ Madness\ Returns/AliceGame/Config >/dev/null 2>&1
}
# install_config_to_steamapps_config
function install_config_to_steamapps_config {
7z e steamapps_config/Config.7z -y -o/home/$USER/.local/share/Steam/steamapps/common/Alice\ Madness\ Returns/AliceGame/Config >/dev/null 2>&1 
}
# installer
function patcher {
echo "        .:*======= ConzZah's =======*:."; echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~";
echo "ALICE MADNESS RETURNS PATCHER FOR LINUX / STEAM DECK " 
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"; echo ""
echo "   [ ~~~ PRESS ANY KEY TO START PATCHING ~~~ ]"
read -n 1 -s
clear; echo "[ ### REMOVING INTRO MOVIES ### ]"; echo ""
remove_intro_movies
cd config_files; echo "[ ### EXTRACTING CONFIG FILES ### ]"; echo ""
install_config_to_my_documents_config && install_config_to_steamapps_config 
echo "        [ ### DONE ### ]"; echo ""
echo "[ ~~~ PRESS ANY KEY TO EXIT ~~~ ]"
read -n 1 -s
exit
}
clear; patcher
