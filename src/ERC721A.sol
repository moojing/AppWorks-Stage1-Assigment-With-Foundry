pragma solidity 0.8.19;
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/ERC721A.sol";
import "https://github.com/exo-digital-labs/ERC721R/blob/main/contracts/IERC721R.sol";
import "openzeppelin-ownable/Ownable.sol";

contract ERC721ANFT is ERC721A, Ownable {
    uint256 public constant MAX_SUPPLY = 10000;
    uint256 public constant mintPrice = 0.01 ether;
    uint256 public constant maxMintAmount = 20;

    constructor(string memory baseURI) ERC721A("ERC721A", "E721ANFT") {}

    function safeMint(uint amount) public payable {
        require(msg.value * amount >= mintPrice, "Not enough ETH to mint");
        require(
            _numberMint(msg.sender) + amount <= maxMintAmount,
            "Max mint amount reached"
        );

        require(
            _totalMinted() + amount <= MAX_SUPPLY,
            "Not enough NFTs left to mint"
        );

        _safeMint(msg.sender, amount);
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        Address.sendValue(payable(msg.sender), balance);
        payable(msg.sender).transfer(address(this).balance);
    }
}
