// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./ERC20.sol"; 

interface IERC20WithMint is IERC20{
    function mint(uint amount) external;
    function burn(uint amount) external;
}

contract Minter {
    IERC20WithMint private testToken;
     address public adr = msg.sender;

    constructor (){
        testToken = IERC20WithMint(0xDD0e2Be3d43CAACFb90E8632828d405dA302b100);
    }

    event Mint(address txOrigin, address sender);

    function getBalance() public view returns (uint256) {
        // why I can't use testToken.balanceOf[msg.sender]?
        // and you'll get 0 with this function call
        // msg.sender is the address that create the contract, not the contract address!
        // so if you want to get the testToken balance of this contract, you should use address(this)!
        return testToken.balanceOf(address(this));
    }

     function getTotalSupply() public view returns (uint) {
         return testToken.totalSupply();
     }

     function mint() public {
         testToken.mint(1000);
        emit Mint(tx.origin, msg.sender);
     }
}