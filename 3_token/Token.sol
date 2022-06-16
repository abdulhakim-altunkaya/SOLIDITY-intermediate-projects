//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


//FIXED SUPPLY The msg.sender receives 1000 MMT token.
//As we dont have any other _mint function in our code, it means
//we have a fixed supply of 1000 tokens. No tokens will be minted in the future.
contract MalmoToken is ERC20{
    constructor() ERC20("MalmoToken", "MMT"){
        _mint(msg.sender, 1000*10**18);
    }
}

//LAZY UNCAPPED SUPPLY
contract MalmoToken2 is ERC20{
    constructor() ERC20("MalmoToken2", "MMT"){}

    function getTokens() external {
        _mint(msg.sender, 1000*10**18);
    }

    function getTokens2(address receiver, uint _amount) external {
        _mint(receiver, _amount);
    }
}