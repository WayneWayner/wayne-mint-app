// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MessageStore {
    string private message;
    uint256 private lastTimestamp;


    function setMessage(string memory _message) public {
        message = _message;
        lastTimestamp = block.timestamp;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

        function getLastTimestamp() public view returns (uint256) {
        return lastTimestamp;
    }
}
