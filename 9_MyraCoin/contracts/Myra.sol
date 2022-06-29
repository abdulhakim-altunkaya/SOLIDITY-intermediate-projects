//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Myra is ERC20 {
    constructor() ERC("MyraCoin", "MMCC") {
        _mint(msg.sender, 100*10**18)
    }
}