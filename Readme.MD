# Celestia blockspacerace rollup

# Description 

This rollup can be used to store messages on it. You have the functionality to store messages,get messages and get the timestamp of the message. If this is not the killer application, I don't know what is.

Joking aside. This is how it works:

Prepare your machine for running ethermint 

```
cd $HOME
git clone https://github.com/celestiaorg/ethermint.git
cd ethermint
make install
```
cd ethermint
Start ethermint

```
NAMESPACE_ID=$(openssl rand -hex 8)
DA_BLOCK_HEIGHT=$(curl https://celestia.rpc.waynewayner.de/block | jq -r '.result.block.header.height')
ethermintd start --rollkit.aggregator true --rollkit.da_layer celestia --rollkit.da_config='{"base_url":"http://localhost:26659","timeout":60000000000,"gas_limit":6000000,"fee":6000}' --rollkit.namespace_id $NAMESPACE_ID --rollkit.da_start_height $DA_BLOCK_HEIGHT
```

Install foundry

```
curl -L https://foundry.paradigm.xyz | bash
source ~/.bashrc
foundryup
```

Clone this repo

git clone 



