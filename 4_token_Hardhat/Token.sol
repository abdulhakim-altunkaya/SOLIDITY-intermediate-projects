//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


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

    //onlyOwner which is a modifier of Ownable.sol is by default the account which deployed the contract.
    function getTokens2(address receiver, uint _amount) external onlyOwner {
        _mint(receiver, _amount);
    }
}

//LAZY CAPPED SUPPLY
//To use a lazy capped system, we need to inherit from ERC20Capped.sol contract
//ERC20Capped includes ERC20 methods as well. Therefore we can use ERC20 methods as well, we do not need inherit from it separetely.
contract MalmoToken3 is ERC20Capped {

    constructor(uint cap) ERC20("MalmoToken3", "MMT") ERC20Capped(cap){}

    function getTokens3() external {
        _mint(msg.sender, 1000*10**18);
    }
    
}