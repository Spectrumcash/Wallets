#! /bin/bash

## Definitions 
#define port 
port=44820

get_ip () {
# Get server primary IPv4 address
ipaddress=$(curl ipinfo.io/ip)
}

spe_set_mn () {
# Let Write the masternode information to the spectrum config 
echo "masternode=1
masternodeaddr=${ipaddress}:${port}
masternodeprivkey=${masternodegenkey}
" >> ~/.Spectrum/Spectrum.conf
}

# lets install and get the Spectrum daemon
wget https://github.com/Spectrumcash/Wallets/raw/master/Linux_Spectrumd_2.0.0.0.tar.gz
tar -xvf  Linux_Spectrumd_2.0.0.0.tar.gz
chmod +x Spectrumd
mv Spectrumd /usr/local/bin
Spectrumd -daemon
sleep 10

masternodegenkey=$(Spectrumd masternode genkey)


Spectrumd stop
sleep 10 
pkill -f Spectrumd 
sleep 10 

echo " let make the config better now"
sed -i '/staking=1/d'  ~/.Spectrum/Spectrum.conf
echo "staking=0" >> ~/.Spectrum/Spectrum.conf

get_ip

spe_set_mn
sleep 10 
Spectrumd -daemon
sleep 10 


stty -echo
echo 
echo
echo "continue in controller wallet"
echo "1. send 10m XSM to your controller wallet address and wait 15 confirmations"
echo "2. use in debug window masternode outputs command to see TrxID and TrxNbr"
echo "3.Write masternode.conf with line:" 
echo
echo MyMN ${ipaddress}:${port} ${masternodegenkey} TrxID TrxNbr
echo

stty echo
