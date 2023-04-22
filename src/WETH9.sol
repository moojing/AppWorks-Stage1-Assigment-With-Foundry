// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./IWETH9.sol";
import {IERC20} from "openzeppelin-erc20/IERC20.sol";

contract WETH9 is IWETH9, IERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Test";
    string public symbol = "TEST";
    uint public decimals = 18;

    event Mint(address txOrigin, address sender);

    function transfer(address to, uint256 amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // allow spender to transfer particular amount of allowance
    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(
            allowance[from][msg.sender] >= amount,
            "WETH9: insufficient allowance"
        );
        // reduce the amount of the from's allowance for msg.sender
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function mint(uint amount) external {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
        emit Mint(tx.origin, msg.sender);
    }

    function deposit() external payable override {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0x0), msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external override {
        require(_amount <= balanceOf[msg.sender], "WETH9: insufficient funds");
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
        require(success, "WETH9: failed to send ether");

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Withdrawal(msg.sender, _amount);
        emit Transfer(msg.sender, address(0x0), _amount);
    }

    receive() external payable {
        balanceOf[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0x0), msg.sender, msg.value);
    }
}
