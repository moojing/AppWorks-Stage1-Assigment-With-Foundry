// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// mapping is like a dictonary in py. 

contract Mapping {
    mapping(address => uint) public balances; 
    mapping(address => mapping(address => bool)) public isFriend; 
    
    function examples () external {
        balances[msg.sender] = 123; 
        uint bal = balances[msg.sender];
        // address 1 is not in the balances mapping, so we'll get 0 here.
        // the default value of uint is 0.
        uint bal2 = balances[address(1)]; 
        
        balances[msg.sender] += 456; 

        delete balances[msg.sender];
        isFriend[msg.sender][address(this)] = true; 
    }
}
 