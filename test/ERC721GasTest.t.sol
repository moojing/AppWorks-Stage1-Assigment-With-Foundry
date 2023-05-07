pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../src/ERC721ANFT.sol";
import "../src/ERC721EnumerableNFT.sol";

contract ERC721GasTest is Test {
    address user1;
    address user2;

    function setUp() public {
        user1 = makeAddr("user1");
        user2 = makeAddr("user2");
        // give user 1 some ether user vm function
        vm.deal(user1, 1 ether);
    }

    function testMintFailed() public {
        ERC721EnumerableNFT token = new ERC721EnumerableNFT();
        ERC721ANFT tokenA = new ERC721ANFT();
        vm.deal(user1, 1 ether);
        vm.startPrank(user1);
        vm.expectRevert("Not enough ETH to mint");
        token.safeMint(1);
        vm.expectRevert("Not enough ETH to mint");
        tokenA.safeMint(1);
        vm.stopPrank();
    }

    function testMintERC721Enumerable() public {
        ERC721EnumerableNFT tokenEnumerable = new ERC721EnumerableNFT();
        vm.startPrank(user1);
        tokenEnumerable.safeMint{value: 0.1 ether}(10);
        console.logUint(tokenEnumerable.tokenOfOwnerByIndex(user1, 0));

        assertEq(tokenEnumerable.tokenOfOwnerByIndex(user1, 0), 1);
        assertEq(tokenEnumerable.tokenOfOwnerByIndex(user1, 9), 10);

        vm.stopPrank();
    }

    function testMintERC721A() public {
        ERC721ANFT token = new ERC721ANFT();
        vm.startPrank(user1);
        token.safeMint{value: 0.1 ether}(10);
        assertEq(token.ownerOf(0), user1);
        assertEq(token.ownerOf(9), user1);
        vm.stopPrank();
    }

    function testApproveERC721Enumerable() public {
        ERC721EnumerableNFT tokenEnumerable = new ERC721EnumerableNFT();
        vm.startPrank(user1);
        tokenEnumerable.safeMint{value: 0.1 ether}(10);
        tokenEnumerable.approve(user2, 1);
        assertEq(tokenEnumerable.getApproved(1), user2);
        vm.stopPrank();
    }

    function testApproveERC721A() public {
        ERC721ANFT token = new ERC721ANFT();
        vm.startPrank(user1);
        token.safeMint{value: 0.1 ether}(10);
        token.approve(user2, 0);
        assertEq(token.getApproved(0), user2);
        vm.stopPrank();
    }

    function testTransferERC721Enumerable() public {
        ERC721EnumerableNFT tokenEnumerable = new ERC721EnumerableNFT();
        vm.startPrank(user1);
        tokenEnumerable.safeMint{value: 0.1 ether}(10);
        tokenEnumerable.safeTransferFrom(user1, user2, 1);
        assertEq(tokenEnumerable.tokenOfOwnerByIndex(user2, 0), 1);
        vm.stopPrank();
    }

    function testTransferERC721A() public {
        ERC721ANFT token = new ERC721ANFT();
        vm.startPrank(user1);
        token.safeMint{value: 0.1 ether}(10);
        token.safeTransferFrom(user1, user2, 0);
        assertEq(token.ownerOf(0), user2);
        vm.stopPrank();
    }
}
