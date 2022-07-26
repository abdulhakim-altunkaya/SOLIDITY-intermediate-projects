//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Nusaybin is ERC721, Ownable {
    uint256 public mintPrice = 0.05 ether;
    uint256 public totalSupply;
    uint256 public maxSupply;
    bool public isMintEnabled;

    //the number of nft each wallet has
    //Also by using this mapping, we can prevent a single wallet 
    //to mint all nft. We can set a limit.
    mapping(address => uint256) public mintedWallets;

    constructor() payable ERC721("Nusaybin", "NSBN") {
        maxSupply = 2;
    }

    function toggleIsMintEnabled() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    function mint() external payable {
        require(isMintEnabled, "minting not enabled");
        require(mintedWallets[msg.sender] < 1, "exceeds max quota per wallet");
        require(msg.value == mintPrice, "wrong value");
        require(maxSupply > totalSupply, "sold out");

        mintedWallets[msg.sender]++;
        totalSupply++;
        uint256 tokenId = totalSupply; // As we have set tokenId to 1 (by saying totalSupply++; in the line above), token ids will start from 1 not from 0.

        _safeMint(msg.sender, tokenId);
    }
}