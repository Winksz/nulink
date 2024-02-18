#!/bin/bash

printBlue() {
    echo -e "\e[34m$1\e[0m"
}

printGreen() {
    echo -e "\e[32m$1\e[0m"
}

error_exit() {
    echo "$1" 1>&2
    exit 1
}

if [ "$EUID" -ne 0 ]; then
    error_exit "Цей сценарій вимагає прав адміністратора. Запустіть його з правами sudo."
fi


printBlue "     _   _       _     _       _           "            
printBlue "    | \ | |_   _| |   (_)_ __ | | __       "            
printBlue "    |  \| | | | | |   | | '_ \| |/ /       "           
printBlue "    | |\  | |_| | |___| | | | |   <        "            
printBlue "    |_| \_|\__,_|_____|_|_| |_|_|\_\       "            
printBlue "                         by Fearless       "

sleep 5

echo ""
printGreen "Відкриваємо порти" & sleep 2
sudo ufw allow 9151
sudo ufw allow 9151/tcp

echo ""
printGreen "Оновлюємо сервер" & sleep 2
echo ""
sudo apt update
sudo apt install python3.9 -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

echo ""
printGreen "Завантажуємо GETH" & sleep 2
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.23-d901d853.tar.gz
tar -xvzf geth-linux-amd64-1.10.23-d901d853.tar.gz

echo ""
printGreen "Переходимо в папку" & sleep 2
echo ""
cd geth-linux-amd64-1.10.23-d901d853/

echo ""
printGreen "Створюэмо Ethereum акаунт та сховище" & sleep 2
printGreen "Вам буде запропоновано ввести пароль і підтвердити пароль. Будь ласка, запам'ятайте цей пароль для пізнього використання." & sleep 2
echo ""
./geth account new --keystore ./keystore

echo ""
printGreen "Продовжте встановлення, якщо ви зберегли введений пароль, public address of the key та path of the secret key file" & sleep 2
echo ""
read -p "Continue installation? (y/n): " choice
case "$choice" in
  y|Y ) 
    echo "Continuation..." & sleep 2
    ;;
  n|N ) 
    echo "Cancelled."
    exit 0
    ;;
  * ) 
    echo "Please enter 'y' or 'n'."
    exit 1
    ;;
esac

echo ""
printGreen "Оновлюємо докер" & sleep 2
echo ""
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo ""
printGreen "Завантажуємо останє зображеня NuLink" & sleep 2
echo ""
sudo docker pull nulink/nulink:latest

echo ""
printGreen "Створюємо папку NuLink" & sleep 2
echo ""
cd $HOME
sudo mkdir nulink

echo ""
printGreen "Перевіряємо чи створилась папка" & sleep 2
echo ""
if [ -d $HOME/nulink ]; then
    echo "Папка існує..." & sleep 2
else
    echo "Папка не існує..." & sleep 2
fi

echo ""
printGreen "Якщо папка існує, продовжіть встановлення" & sleep 2
echo ""
read -p "Continue installation? (y/n): " choice

case "$choice" in
  y|Y ) 
    echo "Continuation..." & sleep 2
    ;;
  n|N ) 
    echo "Cancelled."
    exit 0
    ;;
  * ) 
    echo "Please enter 'y' or 'n'."
    exit 1
    ;;
esac
echo ""
printGreen "Copying your repository, enter your value, for example: UTC--2024-02-17T19-37-42.712584935Z--02b2d1f206126cdb0b9a19c5c5b44d6c84ec8e2c" & sleep 2
echo ""
read -p "Your UTC: " UTC 
cp $HOME/geth-linux-amd64-1.10.23-d901d853/keystore/$UTC /root/nulink

echo ""
printGreen "Сheck if the UTC file has been copied" & sleep 2
echo ""
cd $HOME/nulink
ls -la

echo ""
printGreen "If you see your UTC file, continue with the installation" & sleep 2
echo ""
read -p "Continue installation? (y/n): " choice
case "$choice" in
  y|Y ) 
    echo "Continuation..." & sleep 2
    ;;
  n|N ) 
    echo "Cancelled."
    exit 0
    ;;
  * ) 
    echo "Please enter 'y' or 'n'."
    exit 1
    ;;
esac

cd $HOME

echo ""
printGreen "Permission granted to the NuLink folder" & sleep 2
echo ""
chmod -R 777 $HOME/nulink

printGreen "Set the passwords that were specified when creating Ethereum" & sleep 2
echo ""
read -p "Enter your password: " PASSWORD 
export NULINK_KEYSTORE_PASSWORD=$PASSWORD
export NULINK_OPERATOR_ETH_PASSWORD=$PASSWORD

echo ""
printGreen "Check if your passwords are displayed, two of your passwords should be displayed" & sleep 2
echo ""
echo $NULINK_KEYSTORE_PASSWORD
echo $NULINK_OPERATOR_ETH_PASSWORD

read -p "Continue installation? (y/n): " choice
case "$choice" in
  y|Y ) 
    echo "Continuation..." & sleep 2
    ;;
  n|N ) 
    echo "Cancelled."
    exit 0
    ;;
  * ) 
    echo "Please enter 'y' or 'n'."
    exit 1
    ;;
esac
echo ""
printGreen "Initializing the node configuration"
echo ""
printGreen "Replacing Public address of the key and Path of the secret key file" & sleep 2
printGreen "Example: UTC--2024-02-17T19-37-42.712584935Z--02b2d1f206126cdb0b9a19c5c5b44d6c84ec8e2c" 
read -p "Path of the secret key file: " KEYSTORE
printGreen "Example: 0x...................." 
read -p "Public address of the key: " ADDRESS



docker run -it --rm \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
nulink/nulink nulink ursula init \
--signer keystore:///code/$KEYSTORE \
--eth-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--network horus \
--payment-provider https://data-seed-prebsc-2-s2.binance.org:8545 \
--payment-network bsc_testnet \
--operator-address $ADDRESS \
--max-gas-price 10000000000

echo ""
printGreen "We start the node" & sleep 2
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready



echo ""
echo ""
printGreen "If you saw the inscription, for example: Operator 0x.................... is not bonded to a staking provider" sleep 2
printGreen "Go to the dashboard, send 0.1 BNB to the worker address and stake 10 NLK" sleep 2
printGreen "If you see a different result, write to us in Discord" & sleep 2
echo ""
printGreen "Checking the status, logs, a possible delay of 1 minute, please wait"
echo ""
docker logs -f ursula

