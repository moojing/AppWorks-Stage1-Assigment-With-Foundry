// SPDX-License-Identifier: UNLICENSED
interface IWETH9 {
    event Deposit(address indexed dst, uint amount);
    event Withdrawal(address indexed src, uint amount);

    function deposit() external payable;

    function withdraw(uint256 _amount) external;
}
