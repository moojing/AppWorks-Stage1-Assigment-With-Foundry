// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {IFiatTokenV2} from "../src/FiatToken.sol";
import {FiatTokenProxy} from "../src/Proxy.sol";

contract FakeUSDC is Test {
    address user1;
    address user2;
    string RPC_URL = "https://1rpc.io/eth";
    uint256 mainnetFork;
    FiatTokenProxy proxy;
    IFiatTokenV2 usdcProxy;

    function setUp() public {
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        mainnetFork = vm.createFork(RPC_URL);
        address USDC_ADDR = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;

        usdcProxy = IFiatTokenV2(USDC_ADDR);
        // vm.deal(address(user1), 10 ether);
    }

    function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
        // console.logUint(vm.activeFork());
        console.logAddress(usdcProxy.owner());
    }
}
