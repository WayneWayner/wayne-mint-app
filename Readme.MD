# Celestia blockspacerace rollup

## Description 

This rollup can be used to store messages on it. You have the functionality to store messages,get messages and get the timestamp of the message. If this is not the killer application, I don't know what is. Joking aside. This is far away from being a killer application.

## Steps

Prepare your machine for running ethermint 

```
cd $HOME
git clone https://github.com/celestiaorg/ethermint.git
cd ethermint
make install
```

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

```
cd $HOME
git clone https://github.com/WayneWayner/wayne-mint-app.git
cd wayne-mint-app
```


The smart contract can be found here [here](src/MessageStore.sol)

As a responsible developer, we test the contract beforehand, of course.

```
forge test -vv
```

If all tests passed we are going to deploy. Run the following to start anvil

```
anvil --port 9545
```

In another terminal we are setting up the env vars. In my case the following:

```
export ANVIL_KEY=0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
export RPC_URL=http://127.0.0.1:9545
```

Now we deploy locally 

```
forge script script/MessageStore.s.sol:MessageStoreScript --fork-url \
$RPC_URL  --private-key $ANVIL_KEY --broadcast
```

If you see something like that you are good to go
```
##### anvil-hardhat
✅ Hash: 0x7a1ab37b9a5282cec019db964a14595a47a9b1b39fcd6de0dc3c106986d4e890
Contract Address: 0x5fbdb2315678afecb367f032d93f642f64180aa3
Block: 1
Paid: 0.001042312 ETH (260578 gas * 4 gwei)


Transactions saved to: /home/waynewayner/git/wayne-rollup/wayne-mint-app/broadcast/MessageStore.s.sol/31337/run-latest.json



==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.001042312 ETH (260578 gas * avg 4 gwei)

Transactions saved to: /home/waynewayner/git/wayne-rollup/wayne-mint-app/broadcast/MessageStore.s.sol/31337/run-latest.json
```

Next we test our contract

```
cast send $CONTRACT_ADDRESS "setMessage(string)" "Hello World" --private-key $ANVIL_KEY --rpc-url $RPC_URL

# Output
blockHash               0x3bc27096bdc1177e9bbc24b94dd8405f348d000f554cd5a9223fcc4808a59308
blockNumber             2
contractAddress         
cumulativeGasUsed       66727
effectiveGasPrice       3877171483
gasUsed                 66727
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root                    
status                  1
transactionHash         0x3b285d3c0edb1658b51df410544cd0b0e7da10b9c1c93e7ec86acc0c39e433c2
transactionIndex        0
type                    2


cast call $CONTRACT_ADDRESS "getMessage()(string)" --rpc-url $RPC_URL
# Output
Hello World
```

If you receive an Hello World the contract seems to be working.


Deploy it to the ethermint chain

```
PRIVATE_KEY=$(ethermintd keys unsafe-export-eth-key mykey --keyring-backend test)
forge script script/MessageStore.s.sol:MessageStoreScript --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast

# Output
[⠆] Compiling...
No files changed, compilation skipped
Script ran successfully.

EIP-3855 is not supported in one or more of the RPCs used.
Unsupported Chain IDs: 9000.
Contracts deployed with a Solidity version equal or higher than 0.8.20 might not work properly.
For more information, please see https://eips.ethereum.org/EIPS/eip-3855

## Setting up (1) EVMs.

==========================

Chain 9000

Estimated gas price: 4.175712892 gwei

Estimated total gas used for script: 338670

Estimated amount required: 0.00141418868513364 ETH

==========================

###
Finding wallets for all the necessary addresses...
##
Sending transactions [0 - 0].
⠁ [00:00:00] [#######################################################################################] 1/1 txes (0.0s)
Transactions saved to: /home/waynewayner/git/wayne-rollup/wayne-mint-app/broadcast/MessageStore.s.sol/9000/run-latest.json

##
Waiting for receipts.
⠉ [00:00:03] [###################################################################################] 1/1 receipts (0.0s)
##### evmos-testnet
✅ Hash: 0x5b60f3ac523a3e09e2a9bea8c1bb739268fc6f32ab88c66105d0e36d1e30ae5d
Contract Address: 0x8d8049b46572cc5864da74066354a724d88c6db7
Block: 5
Paid: 0.000915550758845756 ETH (260516 gas * 3.514374391 gwei)


Transactions saved to: /home/waynewayner/git/wayne-rollup/wayne-mint-app/broadcast/MessageStore.s.sol/9000/run-latest.json



==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.000915550758845756 ETH (260516 gas * avg 3.514374391 gwei)

Transactions saved to: /home/waynewayner/git/wayne-rollup/wayne-mint-app/broadcast/MessageStore.s.sol/9000/run-latest.json
```
After you successfully deployed it to ethermint you can call the functions with the given contract address
```
export CONTRACT_ADDRESS=0x8d8049b46572cc5864da74066354a724d88c6db7
cast send $CONTRACT_ADDRESS "setMessage(string)" "Hello World" --private-key $PRIVATE_KEY --rpc-url http://localhost:8545
cast call $CONTRACT_ADDRESS "getMessage()(string)" --rpc-url http://localhost:8545
```

Thats it. 
