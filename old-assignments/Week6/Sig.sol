// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// the process of signature is as follows:
// 1. hash the message
// 2. add the prefix "\x19Ethereum Signed Message:\n32"
// 3. sign the hash
// 4. recover the signer address
// 5. compare the signer address with the expected address

contract verifySig {
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 messageHash = getMessageHash(_message);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recover(ethSignedMessageHash, _sig) == _signer;
    }

    function getMessageHash(
        string memory _message
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedMessageHash(
        bytes32 _messageHash
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    _messageHash
                )
            );
    }

    function recover(
        bytes32 _ethSignedMessageHash,
        bytes memory _sig
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = _split(_sig);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function _split(
        bytes memory _sig
    ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(_sig.length == 65, "invalid signature length");

        assembly {
            // this will go to memory , 32bytes from the pointer that we provide into this input.
            // add is used to skip the first 32 bytes from the pointer of _sig,
            // because it holds the length of the array.
            r := mload(add(_sig, 32))
            // skip 32 bytes for the length of the array and 32 bytes for r
            s := mload(add(_sig, 64))
            // skip 32 bytes for the length of the array, 32 bytes for r and 32 bytes for s
            v := byte(0, mload(add(_sig, 96)))
        }

        // the return is implicit. so you don't to write return (r, s, v);
        // return (r, s, v);
    }
}
