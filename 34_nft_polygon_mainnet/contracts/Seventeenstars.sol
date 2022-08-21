//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Seventeenstars is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    //Setting max minting per wallet address is not needed.
    //This will be used only for information purposes.
    mapping(address => uint256) public mintedWallets;

    //Owner cannot mint more than 20 (17 for nfts and 3 for testing)
    //no function to change this.
    //require statement inside safeMint checks this.
    uint256 public maxSupply = 20;

    //toggling enable-minting is only for security purposes.
    bool public isMintAllowed = true;
    function toggleMinting() public {
        isMintAllowed = !isMintAllowed;
    }

    //minting price is only for display purposes. 
    uint256 public mintingPrice = 0;
    function changeMintingPrice(uint256 newPrice)  external onlyOwner {
        mintingPrice = newPrice;
    }

    constructor() ERC721("Seventeenstars", "SEVENS") {}

    function safeMint() {}
}


    //setting minting price is also an extra caution. Does not have an effect on Contract.
    uint256 public mintingPrice = 0;
    function changeMintingPrice(uint256 newPrice) external onlyOwner {
        mintingPrice = newPrice;
    }

    constructor() ERC721("Nineteenstars", "NINES") {}

    function safeMint(address to, string memory uri) public payable {
        require(mintingPrice <= msg.value, "pay the minting price");
        require(isMintAllowed == true, "minting must be enabled by Owner");

        uint tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "this contract cannot mint more nfts");

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function burnNFT(uint256 tokenId) external {
        _burn(tokenId);
    }

    //overrides required by solidity
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }