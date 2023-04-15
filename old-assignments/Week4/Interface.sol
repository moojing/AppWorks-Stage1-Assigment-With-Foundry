// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// interface is used to call another contract
interface ICounter {
    function count() external view returns (uint);

    function inc() external;
}

contract CallInterface {
    uint public count; 

    function examples(address _counter) external {
        ICounter(_counter).inc();
        // get the count value from another contract;
        // how does it cost to call another contract? 
        count = ICounter(_counter).count();
    }
}
