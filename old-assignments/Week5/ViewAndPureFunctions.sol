// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract ViewAndPureFunctions {
    uint public num; 
    
    //view : read data from a blockchain 
    function viewFunc() external view returns (uint) {
        return num;
    }

    //view : didn't update or read the data on the blockchain
    function pureFunc() external pure returns (uint) {
        return 1; 
    }

    function addToNum(uint x) external view returns (uint){
        return num + x; 
    }
    
    //doesn't read any data from blockchain
    function addToNum(uint x, uint y) external pure returns (uint){
        return x +y ; 
    }
}