// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// 378 gas
contract Constants {
     address public constant MY_ADDRESS = 0x8865d9736Ad52c6cdBbEA9bCd376108284CFd0e4;
     uint public constant MY_UINT = 123; 
}
// 2489 gas
contract Var {
    address public MY_ADDRESS = 0x8865d9736Ad52c6cdBbEA9bCd376108284CFd0e4;
}