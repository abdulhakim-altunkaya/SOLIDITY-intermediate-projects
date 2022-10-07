//SPDX-License-Identifier: MIT

pragma solidity >=0.8.1;

import "./ERC20.sol";
import "./ERC20Capped.sol";

contract Token is ERC20Capped {

    constructor(uint cap) ERC20("FridayWork", "FRIDAY") ERC20Capped(cap *(10**18)) {

    }

    function mintTokens(address to, uint amount) external {
        uint amount2 = amount * (10**18);
        _mint(to, amount2);
    }

    function burnTokens(uint amount) external {
        uint amount2 = amount*(10**18);
        _burn(msg.sender, amount2);
    }

    function approvePool(address pool, uint amount) external {
        uint amount2 = amount*(10**18);
        approve(pool, amount2);
    }

}