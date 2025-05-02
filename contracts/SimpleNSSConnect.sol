// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SimpleNSSConnect {
    string public message;
    
    constructor() {
        message = "Hello, NSS Connect!";
    }
    
    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    
    function getMessage() public view returns (string memory) {
        return message;
    }
}
