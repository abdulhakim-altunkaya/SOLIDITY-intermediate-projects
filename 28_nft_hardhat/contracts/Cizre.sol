//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cizre is ERC721, ERC721URIStorage, Ownable  {

    uint256 public mintPrice = 500000000000000;
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    constructor() ERC721("Cizre", "CZR") {}

    function safeMint(address to, string memory uri) public onlyOwner payable {
        require(msg.value >= mintPrice, "min minting price is 0.0005 eth");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function setMintingPrice(uint256 _newPrice) external onlyOwner {
        mintPrice = _newPrice;
    }

    function returnMintingPrice() external view returns(uint256) {
        return mintPrice;
    }

    function burnToken(uint256 tokenId) external {
        _burn(tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(tokenId);
    }
}