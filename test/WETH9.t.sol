// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/WETH9.sol";

contract WETH9Test is Test {
    address user1;
    address user2;
    WETH9 weth9;

    event Deposit(address indexed dst, uint amount);
    event Withdrawal(address indexed src, uint amount);

    function setUp() public {
        string
            memory mnemonic = "test test test test test test test test test test test junk";
        uint256 privateKey1 = vm.deriveKey(mnemonic, 0);
        uint256 privateKey2 = vm.deriveKey(mnemonic, 1);

        user1 = vm.addr(privateKey1);
        user2 = vm.addr(privateKey2);

        vm.deal(address(user1), 10 ether);
        weth9 = new WETH9();
    }

    function testDeposit() public {
        vm.prank(user1);

        //Case 3: deposit 應該要 emit Deposit event
        vm.expectEmit(true, false, false, true);
        emit Deposit(user1, 0.1 ether);

        weth9.deposit{value: 0.1 ether}();

        // Case 1: deposit 應該將與 msg.value 相等的 ERC20 token mint 給 user
        assertEq(weth9.balanceOf(user1), 0.1 ether);

        // Case 2: deposit 應該將 msg.value 的 ether 轉入合約
        assertEq(address(weth9).balance, 0.1 ether);
        emit log_uint(weth9.balanceOf(user1));
    }

    function testWithdraw() public {
        vm.startPrank(address(user1));
        vm.deal(address(user1), 10 ether);
        weth9.deposit{value: 10 ether}();

        uint originalTotalSupply = weth9.totalSupply();
        uint originalUserBalance = address(user1).balance;
        // Case 6: withdraw 應該要 emit Withdraw event
        vm.expectEmit(true, false, false, true);
        emit Withdrawal(user1, 0.01 ether);

        weth9.withdraw(0.01 ether);

        //Case 4: withdraw 應該要 burn 掉與 input parameters 一樣的 erc20 token
        assertEq(weth9.totalSupply(), originalTotalSupply - 0.01 ether);

        //Case 5: withdraw 應該將 burn 掉的 erc20 換成 ether 轉給 user
        assertEq(address(user1).balance, originalUserBalance + 0.01 ether);
        vm.stopPrank();
    }

    function testTransfer() public {
        vm.startPrank(address(user1));
        weth9.deposit{value: 10 ether}();

        weth9.transfer(user2, 3 ether);
        // Case 7: transfer 應該要將 erc20 token 轉給別人
        assertEq(weth9.balanceOf(user2), 3 ether);
    }

    function testApprove() public {
        vm.startPrank(address(user1));
        weth9.deposit{value: 10 ether}();

        weth9.approve(user2, 3 ether);
        //Case 7: transfer 應該要將 erc20 token 轉給別人
        assertEq(weth9.allowance(user1, user2), 3 ether);
    }

    function testTransferFrom() public {
        vm.startPrank(address(user1));
        weth9.deposit{value: 10 ether}();

        weth9.approve(user2, 3 ether);
        vm.stopPrank();

        vm.startPrank(address(user2));
        weth9.transferFrom(user1, user2, 2 ether);

        // Case 9: transferFrom 應該要可以使用他人的 allowance
        assertEq(weth9.balanceOf(user2), 2 ether);

        //Case 10: transferFrom 後應該要減除用完的 allowance
        assertEq(weth9.allowance(user1, user2), 1 ether);
        vm.stopPrank();
    }

    function testMint() public {
        vm.startPrank(address(user1));
        weth9.mint(10 ether);
        assertEq(weth9.balanceOf(user1), 10 ether);
        assertEq(weth9.totalSupply(), 10 ether);
    }

    function testReveive() public {
        vm.startPrank(address(user1));

        vm.expectEmit(true, false, false, true);
        emit Deposit(user1, 1 ether);

        address(weth9).call{value: 1 ether}("");
        assertEq(weth9.balanceOf(user1), 1 ether);
        assertEq(weth9.totalSupply(), 1 ether);
    }

    function testBurn() public {
        vm.startPrank(address(user1));
        weth9.deposit{value: 10 ether}();

        weth9.burn(1 ether);
        assertEq(weth9.balanceOf(user1), 9 ether);
        assertEq(weth9.totalSupply(), 9 ether);
    }
}
