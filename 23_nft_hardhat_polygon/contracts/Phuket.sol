pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Phuket is ERC721, ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.counter private _tokenIds;

    constructor() ERC721("Phuket", "PHU") {}

    function totalSupply() external view returns (uint) {
        return _tokenIds.current();
    }

    function contractURI() public pure returns(string memory) {
        return "JSON LİNK";
    }
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function mintItem(address minter, string memory tokenURI) public returns (uint) {
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();
        _mint(minter, newItemId);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}



import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Boredcats is ERC721, ERC721URIStorage {

    //Here we are creating a counters library and creating a counters variable.
    //_tokenIdCounter variable will keep track of token id.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    constructor() ERC721("Boredcats", "BC") {}

    //First parameter is the recipient of the newly minted NFT.
    //Second parameter is uri which will describe the metadata of the NFT.
    function safeMint(address to, string memory uri) public {
        uint256 tokenId = _tokenIdCounter.current(); // We are storing the current token id.
        _tokenIdCounter.increment();    //increment the id number by one.
        _safeMint(to, tokenId); // mint the nft. This is the main function.
        _setTokenURI(tokenId, uri); // after minting it, set the metadata to this token id.
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }
}