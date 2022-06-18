//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpindelToken is ERC20 {

    constructor() ERC20("SpindelToken", "SPDL"){
        _mint(msg.sender, 5000*1000**18);
    }


}