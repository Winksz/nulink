#!/bin/bash

printBlue() {
    echo -e "\e[34m$1\e[0m"
}

printBlue "     _   _       _     _       _           "            
printBlue "    | \ | |_   _| |   (_)_ __ | | __       "            
printBlue "    |  \| | | | | |   | | '_ \| |/ /       "           
printBlue "    | |\  | |_| | |___| | | | |   <        "            
printBlue "    |_| \_|\__,_|_____|_|_| |_|_|\_\       "            
printBlue "                         by Fearless       "

sleep 5


echo ""
printGreen "This will remove everything associated with the node" & sleep 2

rm -rf $HOME/nulink
rm -rf $HOME/geth-linux-amd64-1.10.23-d901d853/
rm -rf /etc/apt/keyrings
docker kill ursula
docker rm ursula

printGreen "Everything related to the Nulink node has been successfully deleted"
