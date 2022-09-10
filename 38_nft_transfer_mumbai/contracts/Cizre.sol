//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Cizre is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    //setting max minting per wallet is not needed for this contract. 
    //mintedWallets mapping is only for information purposes and transparency.
    mapping(address => uint) public mintedWallets;

    //max supply
    uint public maxSupply = 50;

    //toggle minting by Owner for security purposes
    bool isMintingEnabled = true;
    function toggleMinting() external onlyOwner {
        isMintingEnabled = !isMintingEnabled;
    }

    //changing minting is an optional power of Owner
    uint public mintingPrice = 0;
    function changeMintingPrice(uint _newMintingPrice) external {
        mintingPrice = _newMintingPrice;
    }

    constructor() ERC721("Cizre", "CZR") {}

    function safeMint(address to, string memory uri) public payable {
        require(mintingPrice <= msg.value, "pay the minting price");
        require(isMintAllowed == true, "minting must be enable by Owner");
        
        uint tokenId = _tokenIdCounter.current();
        require(tokenId < maxSupply, "this contract cannot mint more nft");

        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }


    function burnToken(uint tokenId) public {
        _burn(tokenId);
    }

    //overrides required by Solidity
    function _burn(uint tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint tokenId) public view override(ERC721, ERC721URIStorage) returns(string memory){
        return super.tokenURI(tokenId);
    }

}

