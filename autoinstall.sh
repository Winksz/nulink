#!/bin/bash

printGreen() {
    echo -e "\e[32m$1\e[0m"
}

error_exit() {
    echo "$1" 1>&2
    exit 1
}

if [ "$EUID" -ne 0 ]; then
    error_exit "Даний скрипт потребує прав адміністратора. Запустіть його з правами sudo."
fi

printGreen "Відкриваємо порти" & sleep 2
sudo ufw allow 9151
sudo ufw allow 9151/tcp

printGreen "Оновлюємо сервер" & sleep 2
sudo apt update
sudo apt install python3.9
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

printGreen "Завантажуємо geth" & sleep 2
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.23-d901d853.tar.gz
tar -xvzf geth-linux-amd64-1.10.23-d901d853.tar.gz

printGreen "Переходимо до папки" & sleep 2
cd geth-linux-amd64-1.10.23-d901d853/

printGreen "Створюємо обліковий запис Ethereum та сховище ключів" & sleep 2
./geth account new --keystore ./keystore

printGreen "Продовжіть встановлення якщо ви скопіювали все необхідне" & sleep 2
read -p "Продовжити встановлення? (y/n): " choice

case "$choice" in
  y|Y ) 
    echo "Продовження..." & sleep 2
    ;;
  n|N ) 
    echo "Скасовано."
    exit 0
    ;;
  * ) 
    echo "Будь ласка, введіть 'y' або 'n'."
    exit 1
    ;;
esac

printGreen "Оновлення докера" & sleep 2
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

printGreen "Завантажуємо останнє зображення NuLink" & sleep 2
sudo docker pull nulink/nulink:latest

printGreen "Створюємо папку NuLink" & sleep 2
cd $HOME
sudo mkdir nulink

printGreen "Перевіряємо чи створилась папка" & sleep 2
if [ -d $HOME/nulink ]; then
    echo "Папка існує." & sleep 2
else
    echo "Папка не існує." & sleep 2
fi

printGreen "Якщо папка існує продовжуємо встановлення" & sleep 2
case "$choice" in
  y|Y ) 
    echo "Продовження..."
    ;;
  n|N ) 
    echo "Скасовано."
    exit 0
    ;;
  * ) 
    echo "Будь ласка, введіть 'y' або 'n'."
    exit 1
    ;;
esac

printGreen "Копіюємо ваше сховище, введіть ваше значення, наприклад: UTC--2023-12-31T17-42-14.316243885Z--f3defb90c2f03e904bd9662a1f16dcd1ca69b00a /root/nulink" & sleep 2
read -p "Ваш UTC: "  
cp $HOME/geth-linux-amd64-1.10.23-d901d853/keystore/$UTC /root/nulink

printGreen "Перевіряємо чи скіпювався Ваш файл UTC" & sleep 2
cd $HOME/nulink
ls -la

printGreen "Якщо Ви бачите свій файл UTC, продовжуйте встановлення" & sleep 2
read -p "Продовжити встановлення? (y/n): " choice

case "$choice" in
  y|Y ) 
    echo "Продовження..." & sleep 2
    ;;
  n|N ) 
    echo "Скасовано."
    exit 0
    ;;
  * ) 
    echo "Будь ласка, введіть 'y' або 'n'."
    exit 1
    ;;
esac

printGreen "Надаємо дозвіл на папку NuLink" & sleep 2
chmod -R 777 $HOME/nulink

printGreen "Встановіть пароль, використовуйте пароль, який ви створили раніше" & sleep 2
read -p "Пароль: " PASS  
export NULINK_KEYSTORE_PASSWORD=$PASS
export NULINK_OPERATOR_ETH_PASSWORD=$PASS

printGreen "Перевірте чи відображаються ваші паролі" & sleep 2
echo $NULINK_KEYSTORE_PASSWORD
echo $NULINK_OPERATOR_ETH_PASSWORD

read -p "Продовжити встановлення? (y/n): " choice

case "$choice" in
  y|Y ) 
    echo "Продовження..." & sleep 2
    ;;
  n|N ) 
    echo "Скасовано."
    exit 0
    ;;
  * ) 
    echo "Будь ласка, введіть 'y' або 'n'."
    exit 1
    ;;
esac

printGreen "Ініціалізація конфігурації вузла"
printGreen "Замініть сховище ключів та Публічну адресу (Воркера адресу)" & sleep 2
read -p "Сховище ключів: " KEYSTORE  
read -p "Сховище ключів: " OPERATOR_ADDRES


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
--operator-address $OPERATOR_ADDRES \
--max-gas-price 10000000000


printGreen "Запускаємо вузол" & sleep 2
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready


printGreen "Перевірка статусу, логів" & sleep 2
docker logs -f ursula

printGreen "Встановлення завершено успішно."
