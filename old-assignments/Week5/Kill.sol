// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Kill {

    constructor() payable{
        // you can use message.value to get the amount sending in.
        // balances[msg.sender] += msg.value;
        
        // why it's called msg.value? 
        // In the EVM, interactions with smart contracts are referred to as message calls.
        // This is true whether a user is calling a smart contract directly or if a smart contract is calling another smart contract (internal transaction).
    } 

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns (uint) {
        return 123; 
    }
}

contract Helper {
    // Helper contract will get balance on the contract that has been destroyed.
    function getBalance() external view returns (uint){
        return address(this).balance;
    }
    
    function kill(Kill _kill) external {
        _kill.kill();
    }
}