#!/bin/bash

printGreen

# Функція для виводу повідомлення про помилку та виходу зі скрипту
error_exit() {
    echo "$1" 1>&2
    exit 1
}

# Перевірка чи є у скрипта права адміністратора
if [ "$EUID" -ne 0 ]; then
    error_exit "Даний скрипт потребує прав адміністратора. Запустіть його з правами sudo."
fi

# Оновлення списку пакетів (за необхідності)
apt update || error_exit "Не вдалося оновити список пакетів."

# Встановлення необхідних пакетів (за необхідності)
apt install -y package1 package2 ... || error_exit "Не вдалося встановити пакети."

# Виконання інших команд (за необхідності)
printGreen "Відкриваємо порти"
sudo ufw allow 9151
sudo ufw allow 9151/tcp

printGreen "Оновлюємо сервер"
sudo apt update
sudo apt install python3.9
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1

printGreen "Завантажуємо geth"
wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-1.10.23-d901d853.tar.gz
tar -xvzf geth-linux-amd64-1.10.23-d901d853.tar.gz

printGreen "Переходимо до папки"
cd geth-linux-amd64-1.10.23-d901d853/

printGreen "Створюємо обліковий запис Ethereum та сховище ключів"
./geth account new --keystore ./keystore

printGreen "Продовжіть встановлення якщо ви скопіювали все необхідне"
read -p "Продовжити встановлення? (y/n): " choice

case "$choice" in
  y|Y ) echo "Продовження...";;
  n|N ) echo "Скасовано.";;
  * ) echo "Будь ласка, введіть 'y' або 'n'.";;
esac

printGreen "Оновлення докера"
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

printGreen "Завантажуємо останнє зображення NuLink"
sudo docker pull nulink/nulink:latest

printGreen "Створюємо папку NuLink"
cd $HOME
sudo mkdir nulink

printGreen "Перевіряємо чи створилась папка"
if [ -d $HOME/nulink ]; then
    echo "Папка існує."
else
    echo "Папка не існує."
fi

printGreen "Якщо папка існує продовжуємо встановлення"
case "$choice" in
  y|Y ) echo "Продовження...";;
  n|N ) echo "Скасовано.";;
  * ) echo "Будь ласка, введіть 'y' або 'n'.";;

printGreen "Копіюємо ваше сховище, введіть ваше значення, наприклад: UTC--2023-12-31T17-42-14.316243885Z--f3defb90c2f03e904bd9662a1f16dcd1ca69b00a /root/nulink"
read UTC  
cp $HOME/geth-linux-amd64-1.10.23-d901d853/keystore/$UTC /root/nulink

printGreen "Перевіряємо чи скіпювався Ваш файл UTC"
cd $HOME/nulink
ls -la

printGreen "Якщо Ви бачите свій файл, продовжуйте встановлення"
case "$choice" in
  y|Y ) echo "Продовження...";;
  n|N ) echo "Скасовано.";;
  * ) echo "Будь ласка, введіть 'y' або 'n'.";;





...

# Вивід повідомлення про успішне встановлення
echo "Встановлення завершено успішно."
