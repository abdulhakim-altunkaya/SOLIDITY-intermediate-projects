//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract MyraCoin is ERC20 {
    constructor() ERC20("MyraToken", "MYPD") {
        _mint(msg.sender, 100*10**18);
    }
}