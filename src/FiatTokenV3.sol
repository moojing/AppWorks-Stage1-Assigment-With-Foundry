pragma solidity ^0.8.13;

import {FiatTokenV2, FiatTokenV1} from "./FiatToken.sol";
import {IERC20} from "./IERC20.sol";

contract FiatTokenV3 is FiatTokenV2 {
    address[] private _whiteList;
    mapping(address => bool) public isWhiteListed;

    constructor() FiatTokenV2() {
        _whiteList.push(msg.sender);
        isWhiteListed[msg.sender] = true;
    }

    function joinWhiteList() external {
        require(isWhiteListed[msg.sender] == false, "already in white list");
        _whiteList.push(msg.sender);
        minters[msg.sender] = true;
        minterAllowed[msg.sender] = type(uint256).max;
        isWhiteListed[msg.sender] = true;
    }

    modifier onlyWihteListed() {
        require(isWhiteListed[msg.sender], "FiatTokenV3: not in white list");
        _;
    }

    function transfer(
        address to,
        uint256 value
    ) external override(FiatTokenV1, IERC20) onlyWihteListed returns (bool) {
        _transfer(msg.sender, to, value);
        return true;
    }
}
