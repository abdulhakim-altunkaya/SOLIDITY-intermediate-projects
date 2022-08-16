//SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Cizre is ERC721, ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    mapping(address => uint256) public mintedWallets;
    uint256 public maxSupply = 100;

    //toggle minting
    bool public isMintAllowed = true;
    function toggleMinting() public onlyOwner {
        isMintAllowed = !isMintAllowed;
    }

    //change max supply
    function changeSupply(uint _newAmount) external onlyOwner {
        maxSupply = _newAmount;
    }

    //set minting price
    uint256 public mintPrice = 0;
    function changeMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
    }

    constructor() ERC721("Cizre", "CIZRE"){}

    function safeMint(address to, string memory uri) public payable {
        require(mintedWallets[to] < 80, "this wallet cannot have more than 79 nft");
        require(mintPrice <= msg.value, "pay the minting price");
        require(isMintAllowed == true, "minting must be enabled by owner");

        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "this contract cannot mint more nft");

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //overrides required by solidity
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

}
