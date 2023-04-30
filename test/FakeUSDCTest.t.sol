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

    address USDC_ADDR;
    address ADMIN_ADDR;

    function bytes32ToAddress(
        bytes32 _bytes32
    ) internal pure returns (address) {
        return address(uint160(uint256(_bytes32)));
    }

    function setUp() public {
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        mainnetFork = vm.createFork(RPC_URL);
        USDC_ADDR = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        ADMIN_ADDR = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;

        proxy = FiatTokenProxy(payable(USDC_ADDR));
        usdcProxy = IFiatTokenV2(USDC_ADDR);
        // vm.deal(address(user1), 10 ether);
    }

    function testCanSelectFork() public {
        // select the fork
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
        // console.logUint(vm.activeFork());
    }

    function testGetAdminAddress() public {
        assertEq(
            bytes32ToAddress(
                vm.load(
                    address(proxy),
                    0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b
                )
            ),
            ADMIN_ADDR
        );
    }

    function testUpgrade() {
        vm.startPrank(ADMIN_ADDR);
    }
}
