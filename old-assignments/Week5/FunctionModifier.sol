// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


contract FUnctionModifier{
    bool public paused; 
    uint public count; 
    
    function setPauce( bool _paused) external {
        paused = _paused; 
    }

    // modifier let the logic can be reused
    modifier whenNotPaused() {
        require(!paused, "paused"); 
        _;
    } 

    function inc() external whenNotPaused {
        count += 1; 
    } 
    
    function dec() external whenNotPaused{
        count -= 1; 
    }

    modifier cap(uint _x){
        require(_x < 100, "x>=100");
        _;
    }  

    // input value for modifier
    function incBy(uint _x) external whenNotPaused cap(_x){
        count += _x; 
    }
    
    // sandwich pattern ! 
    modifier sandwich() {
        // code here 
        count += 10; 
        _; 
        //more code here 
        count += 2; 
    }

    function foo() external sandwich {
        count += 1; 
    } 
}