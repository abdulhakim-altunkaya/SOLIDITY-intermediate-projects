//SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract FlowerFox is ERC20Capped {
    address public owner;

    event Minting(address indexed _receiver, uint _amount);

    constructor(uint cap) ERC20("FlowerFox", "FLFX") ERC20Capped(cap * (10**18)) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    function mintTokens(uint _amount) external {
        require(_amount <=10, "max 10 tokens");
        require(_amount >=1, "mint at least 1");
        _mint(msg.sender, _amount*(10**18));
        emit Minting(msg.sender, _amount);
    }

    function donateTokens(address otherContract, uint _amount) external onlyOwner {
        _mint(otherContract, _amount*(10**18));
    }

    function burnTokens(uint _amount) external {
        _burn(msg.sender, _amount*(10**18));
    }


}