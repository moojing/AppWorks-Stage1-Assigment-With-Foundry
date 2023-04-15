// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// cast command:  cast call --from <ACCOUNT> <CONTRACT> "getSelector(string)" "transfer(address,uint256)"
// 0xa9059cbb00000000000000000000000000000000000000000000000000000000
contract FunctionSelector {
    function getSelector(string calldata _func) external pure returns (bytes4) {
        return bytes4(keccak256(bytes(_func)));
    }
}

// contract Receiver {
//     event Log(bytes data);

//     function transfer(address _to, uint _amount) external {
//         emit Log(msg.data);
//     }
// }
