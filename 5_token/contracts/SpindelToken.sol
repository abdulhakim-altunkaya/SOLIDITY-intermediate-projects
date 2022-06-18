//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SpindelToken is ERC20 {

    constructor(uint _initialAmount) ERC20("SpindelToken", "SPDL"){
        _mint(msg.sender, _initialAmount);
    }


}