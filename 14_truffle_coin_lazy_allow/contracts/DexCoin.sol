//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

//LAZY UNCAPPED SUPPLY
contract DexCoin is ERC20 {
    constructor() ERC20("DexCoin", "CATABATIC") {}

    function mintTokens() external {
        _mint(msg.sender, 10*10**18);
    }

    function promtAccess(address spender, uint amount) external {
        approve(spender, amount);
    }

}

