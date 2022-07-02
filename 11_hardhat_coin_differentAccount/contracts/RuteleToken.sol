//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract RuteleToken is ERC20 {

    constructor() ERC20("RuteleToken", "RSAL"){

        _mint(0x8f2541f8372220612121baAb879c6184428de532, 500*10**18);

    }

    function approveContract() public {
        address spender = address(this);
        uint amount
        approve(spender, amount);
    }
}