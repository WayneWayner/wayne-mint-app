// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {MessageStore} from "src/MessageStore.sol";

contract MessageStoreScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        new MessageStore();
        vm.stopBroadcast();
    }
}
