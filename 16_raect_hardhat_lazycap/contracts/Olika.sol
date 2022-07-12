//SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Olika is ERC20Capped {
    constructor(uint cap) ERC20("Olika", "OLIKA") ERC20Capped(cap) {}

    function getTokens() external {
        _mint(msg.sender, 50*10**18);
    }

    
}
