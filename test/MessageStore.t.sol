// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./../lib/forge-std/src/Test.sol";
import "../src/MessageStore.sol";

contract TestMessageStore {
    function testSetAndGetMessage() public {
        MessageStore messageStore = new MessageStore();
        string memory expectedMessage = "Hello, world!";
        messageStore.setMessage(expectedMessage);
        string memory actualMessage = messageStore.getMessage();
        assert(keccak256(bytes(actualMessage)) == keccak256(bytes(expectedMessage)));
    }

    function testGetLastTimestamp() public {
        MessageStore messageStore = new MessageStore();
        uint256 expectedTimestamp = block.timestamp;
        messageStore.setMessage("Hello, world!");
        uint256 actualTimestamp = messageStore.getLastTimestamp();
        assert(actualTimestamp >= expectedTimestamp);
    }
    
}
