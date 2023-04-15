// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Order of inheritance - most base line to derived

contract X {
    function foo() public pure virtual returns (string memory){
        return "X"; 
    }

    function bar() public pure virtual returns (string memory){
        return "X";
    }

    function x() public pure returns (string memory){
        return "X"; 
    } 
}

contract Y is X {
    function foo() public pure virtual override returns (string memory){
        return "Y"; 
    }

    // virtual let child contract to override 
    // use override means you're overriding parent contract's function
    function bar() public pure virtual override returns (string memory){
        return "Y";
    }

    function y() public pure returns (string memory){
        return "Y"; 
    } 
}


contract Z is X,Y {
    function foo() public override(X,Y) pure returns (string memory) {
        return "Z"; 
    }
    // the order with the override is not important
    function bar() public override(Y,X) pure returns (string memory) {
        return "Z"; 
    }
}
