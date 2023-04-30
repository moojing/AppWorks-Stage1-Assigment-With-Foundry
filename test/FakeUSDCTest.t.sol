// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {FiatTokenV2} from "../src/FiatToken.sol";
import {FiatTokenProxy} from "../src/Proxy.sol";
import {FiatTokenV3} from "../src/FiatTokenV3.sol";

contract FakeUSDC is Test {
    address user1;
    address user2;
    string RPC_URL = "https://1rpc.io/eth";
    uint256 mainnetFork;
    FiatTokenProxy proxy;
    FiatTokenV2 usdcProxy;

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
        USDC_ADDR = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        ADMIN_ADDR = 0x807a96288A1A408dBC13DE2b1d087d10356395d2;
        mainnetFork = vm.createFork(RPC_URL);

        proxy = FiatTokenProxy(payable(USDC_ADDR));
        usdcProxy = FiatTokenV2(USDC_ADDR);
        vm.selectFork(mainnetFork);
    }

    function upgradeToV3() public {
        vm.startPrank(ADMIN_ADDR);
        FiatTokenV3 tokenV3 = new FiatTokenV3();
        proxy.upgradeTo(address(tokenV3));
        vm.stopPrank();
    }

    function testCanSelectFork() public {
        assertEq(vm.activeFork(), mainnetFork);
    }

    function testGetAdminAddress() public {
        vm.selectFork(mainnetFork);
        assertEq(vm.activeFork(), mainnetFork);
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

    function testUpgrade() public {
        vm.startPrank(ADMIN_ADDR);
        FiatTokenV3 tokenV3 = new FiatTokenV3();
        proxy.upgradeTo(address(tokenV3));
        assertEq(proxy.implementation(), address(tokenV3));
    }

    function testCanJoinWhiteList() public {
        upgradeToV3();

        vm.startPrank(user1);
        FiatTokenV3 proxyV3 = FiatTokenV3(address(proxy));
        proxyV3.joinWhiteList();
        assertEq(proxyV3.isWhiteListed(user1), true);
        vm.stopPrank();
    }

    function testWhiteListCanMint(uint256 _amount) public {
        // ? use uint256 will cause an error.
        _amount = bound(_amount, 1, type(uint128).max - 1);
        upgradeToV3();

        vm.startPrank(user1);
        FiatTokenV3 proxyV3 = FiatTokenV3(address(proxy));
        proxyV3.joinWhiteList();
        bool success = proxyV3.mint(user1, _amount);
        assertEq(success, true);
        vm.stopPrank();
    }

    function testWhiteListCanTransfer(uint256 _amount) public {
        // ? use uint256 will cause an error.
        _amount = bound(_amount, 1, type(uint128).max - 1);

        upgradeToV3();

        vm.startPrank(user1);

        FiatTokenV3 proxyV3 = FiatTokenV3(address(proxy));
        proxyV3.joinWhiteList();
        proxyV3.mint(user1, _amount);
        bool success = proxyV3.transfer(user2, _amount);
        assertEq(success, true);
        vm.stopPrank();
    }

    function testCantTransfer() public {
        upgradeToV3();

        vm.startPrank(user1);
        FiatTokenV3 proxyV3 = FiatTokenV3(address(proxy));
        vm.expectRevert("FiatTokenV3: not in white list");
        proxyV3.transfer(user2, 100);
        vm.stopPrank();
    }
}
