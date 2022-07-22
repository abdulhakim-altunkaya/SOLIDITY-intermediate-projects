//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Nusaybin is ERC721, ERC721URIStorage {

    uint counter;

    constructor() ERC721("Nusaybin NFT", "NSBN") {}

    function mintNFT(address receiver, string memory tokenUri) external {
        _setTokenURI(counter, tokenUri);
        _safeMint(receiver, counter);
        counter += 1;
    }

        // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

}