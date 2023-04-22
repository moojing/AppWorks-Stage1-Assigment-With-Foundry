// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SaveGas {
    uint public n = 5;

    function noCache() external view returns (uint) {
        uint s = 0;
        for (uint i = 0; i < n; i++) {
            s += i;
        }
    }

    function cache() external view returns (uint) {
        uint s = 0;
        // before running the loop, store the value of n in memory
        uint _n = n;
        for (uint i = 0; i < _n; i++) {
            s += i;
        }

        return s;
    }
}
