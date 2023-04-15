// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;


// 2 ways to call parent constructors
// Order of initialization 

contract S {
    string public name; 
    
    constructor (string memory _name){
        name = _name; 
    }
}

contract T {
    string public text; 
    constructor (string memory _text){
        text = _text; 
    }
}

// how to call parent constructors (S,T) ? 
// method 1 
contract U is S("s"), T("t"){
    
}
// method 2
contract V is S,T{
    constructor(string memory _name, string memory _text) S(_name) T(_text){
        
    }
}
// combined method
contract VV is S("s") ,  T{
    constructor(string memory _name, string memory _text) T(_text) {
        
    }
}

// order of initialization
// S -> T -> V0 
contract V0 is S,T {
    constructor(string memory _name, string memory _text) S(_name) T(_text){
    }
}


// S -> T -> V1
contract V1 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {
        
    }
}

// T -> S -> V2
contract V2 is T,S {
    constructor(string memory _name, string memory _text) S(_name) T(_text){
        
    }
}

// T -> S -> V3
contract V3 is T,S {
    constructor(string memory _name, string memory _text) S(_name) T(_text){
        
    }
}



