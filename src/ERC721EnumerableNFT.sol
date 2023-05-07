// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)

pragma solidity ^0.8.0;
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
contract ERC721EnumerableNFT is ERC721, ERC721Enumerable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant mintPrice = 0.01 ether;
    uint256 public constant maxMintAmount = 20;

    constructor() ERC721("MyNFT", "MNFT") {}

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
    }

    function safeMint(uint amount) public payable {
        require(msg.value * amount >= mintPrice, "Not enough ETH to mint");
        require(
            ERC721.balanceOf(msg.sender) + amount <= maxMintAmount,
            "Max mint amount reached"
        );

        require(
            totalSupply() + amount <= MAX_SUPPLY,
            "Not enough NFTs left to mint"
        );

        for (uint i = 0; i < amount; i++) {
            _safeMint(msg.sender, totalSupply() + 1);
        }
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
