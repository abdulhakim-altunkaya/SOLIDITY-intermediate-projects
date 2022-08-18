//SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Nineteenstars is ERC721, ERC721URIStorage, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    //setting max minting per wallet is not needed for this contract. 
    //mintedWallets mapping is only for information purposes and transparency.
    mapping(address => uint256) public mintedWallets;

    //this variable is making sure that the owner cannot mint more than 19 nft. 
    //Moreover, you can see below that there is no function allowing owner to change this.
    //And also, you can see in safeMint function that this maxSupply is required to be 19.
    uint256 public maxSupply = 20;

    //toggling enable-minting is for just in case security purposes.
    bool public isMintAllowed = true;
    function toggleMinting() external onlyOwner {
        isMintAllowed = !isMintAllowed;
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

}
