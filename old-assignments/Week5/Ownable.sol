// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// openzepplin's ownable contract
//https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

contract Owbable {
    address public owner; 

    constructor () {
        owner = msg.sender; 
    }

    modifier onlyOnwer () {
        require(msg.sender == owner, "not owner");
        _;
    }

    function setOwner( address _newOwner) external onlyOnwer {
        require(_newOwner != address(0), "invalid address");
        owner = _newOwner;
    } 

    function onlyOwnerCanCallThisFunction() external onlyOnwer{
        //code 
    }

    function anyOneCanCall() external {
        //code 
    } 

}