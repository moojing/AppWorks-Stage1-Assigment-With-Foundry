// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// this might be thoudsands of code on the mainnet
contract Counter {
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}