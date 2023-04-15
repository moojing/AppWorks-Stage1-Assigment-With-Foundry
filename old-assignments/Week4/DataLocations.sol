// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// Data Location - storage, memory and calldata 

contract DataLocations {
    struct MyStruct {
        uint foo;
        string text; 
    } 

    mapping(address => MyStruct) public myStructs;
    
    // calldata is not modifiable, it can save the gas.
    function examples(uint[] calldata y, string calldata s) external returns (uint[] memory){
        myStructs[msg.sender] = MyStruct({foo:123, text:"bar"}); 
        
        // state variable 
        // use stroage to update the data.
        MyStruct storage myStruct =  myStructs[msg.sender]; 
        // the origin myStruct data in myStructs will also be chainged.
        myStruct.text = "foo"; 
        // use memory to read the data.
        MyStruct memory readOnly =  myStructs[msg.sender]; 
        // memory -> this change will not be saved.
        readOnly.foo = 456; 
        
        _internal(y);

        uint[] memory memArr = new uint[](3);
        memArr[0] = 234; 
        return memArr;
    }

    function _internal(uint[] memory y) private {
        uint x = y[0];
    }
} 