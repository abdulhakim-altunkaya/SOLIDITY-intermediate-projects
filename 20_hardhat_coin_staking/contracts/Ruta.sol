//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";


contract Ruta is ERC20Capped {

    address internal owner;

    constructor(uint cap) ERC20("Ruta", "RUTA") ERC20Capped(cap * (10 ** 18)) {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    function getTokens(uint _amount) external {
        _mint(msg.sender, _amount * (10 ** 18));
    }

    function donateTokens(address otherContract, uint _amount) external onlyOwner{
        _mint(otherContract, _amount*(10**18));
    }

    function burnTokens(uint _amount) external {
        _burn(msg.sender, _amount*(10**18));
    }

    function getMintedTokens() external view returns(uint256){
        uint256 data = totalSupply();
        return data;
    }
    function getName() external view returns(string memory){
        return name();
    }

}
