// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

// Array - dynamic or fixed size.
// Initialization. 
// Insert (push), get, update, delete, pop,length 
// Creating array in memory 
// Returning array from function 

contract Array {
      uint[] public nums = [1,2,3]; 
      uint[3] public numsFixed = [4,5,6];
      
      function examples() external {
          nums.push(4); //[1,2,3,4];
          uint x = nums[1]; 
          nums[2] = 777; //[1,2,777,4]
          delete nums[1]; // [1,0,777,4]
          nums.pop(); //[1,0,777]
          
          // create an array in memory
          // is has to be a fixed size array
          // can't use pop or push method with a memory array. 
          uint[] memory a = new uint[](5); 
          a[1] = 123;
          
         
          
      } 
    function returnArray() external view returns (uint[] memory) {
              return nums; 
    } 
}