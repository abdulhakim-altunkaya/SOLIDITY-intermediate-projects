// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cizre is ERC721, ERC721URIStorage, Ownable {
    //PART 1: id counter
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    //PART 6: wallets that minted NFT
    mapping(address => uint256) public mintedWallets;

    //PART 7: security function
    bool public isMintEnabled = true;
    function toggleMint() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    //PART 2: constructor
    constructor() ERC721("Cizre", "CIZRE") {}

    //PART 5: minting pricing
    uint256 public mintPrice = 0;
    function setMintPrice(uint256 _newPrice) public onlyOwner {
        mintPrice = _newPrice;
    }
    function getMintPrice() external view returns(uint256) {
        return mintPrice;
    }

    //PART 3: minting function
    function safeMint(address to, string memory uri) payable public onlyOwner {
        require(msg.value >= mintPrice, "pay minting price");
        require(mintedWallets[to] < 3, "max 3 nfts can be minted per wallet");
        require(isMintEnabled == true, "minting is not enabled yet");

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
        mintedWallets[to]++;
    }

    //PART 4: burning function
    function burnToken(uint256 tokenId) external {
        _burn(tokenId);
    }





    //PART 6: overrides required by solidity
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory) {
        return super.tokenURI(tokenId);
    }
}




