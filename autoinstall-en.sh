echo ""
echo "Permission granted to the NuLink folder"
chmod -R 755 $HOME/nulink
sleep 2

echo ""
echo "Set the passwords that were specified when creating Ethereum"
sleep 2
echo ""
read -p "Enter your password: " PASSWORD 
export NULINK_KEYSTORE_PASSWORD=$PASSWORD
export NULINK_OPERATOR_ETH_PASSWORD=$PASSWORD

echo ""
echo "Check if your passwords are displayed, two of your passwords should be displayed"
sleep 2
echo $NULINK_KEYSTORE_PASSWORD
echo $NULINK_OPERATOR_ETH_PASSWORD

read -p "Continue installation? (y/n): " choice
case "$choice" in
  y|Y ) 
    echo "Continuation..."
    sleep 2
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
echo "Initializing the node configuration"
echo ""
echo "Replacing Public address of the key and Path of the secret key file"
sleep 2
echo "Example: UTC--2024-02-17T19-37-42.712584935Z--02b2d1f206126cdb0b9a19c5c5b44d6c84ec8e2c" 
read -p "Path of the secret key file: " KEYSTORE
echo "Example: 0x...................." 
read -p "Public address of the key: " ADDRESS

# Ensure Docker is installed and running
if ! command -v docker &> /dev/null
then
    echo "Docker could not be found, installing..."
    sudo yum install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
fi

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
echo "We start the node"
sleep 2
docker run --restart on-failure -d \
--name ursula \
-p 9151:9151 \
-v /root/nulink:/code \
-v /root/nulink:/home/circleci/.local/share/nulink \
-e NULINK_KEYSTORE_PASSWORD \
-e NULINK_OPERATOR_ETH_PASSWORD \
nulink/nulink nulink ursula run --no-block-until-ready

echo ""
echo "If you saw the inscription, for example: Operator 0x.................... is not bonded to a staking provider"
sleep 2
echo "Go to the dashboard, send 0.1 BNB to the worker address and stake 10 NLK"
sleep 2
echo "If you see a different result, write to us in Discord"
sleep 2
echo "Checking the status, logs, a possible delay of 1 minute, please wait"
echo ""
docker logs -f ursula
