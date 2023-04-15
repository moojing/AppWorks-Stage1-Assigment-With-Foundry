// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// require, revert, assert
// gas refund - save gas
// custom error - save gas
contract Error {
    function testRequire(uint _i) public pure {
        require(_i > 10,"i>10");
    }

    function testRevert(uint i ) public pure {
      if(i > 10){
        // it's better to use revert
        // with lots of if statement
        revert("i>10");
      }
    }

    uint public num = 123;

    function testAssert() public view {
      // use assert to check condtions that should always to be true.
      assert(num == 123);
    }

    function foo(uint _i) public {
      num += 1;
      require(_i < 10, "i>10");
    }
    // custom error is more cheaper than revert
    error MyError(address caller, uint i);

    function testCustomError(uint _i) public  view{
      if( _i > 10){
        // right now custom error is not supported with require
        revert  MyError(msg.sender, _i);
      }
    }
}
