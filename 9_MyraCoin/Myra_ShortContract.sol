//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract MyraCoin is ERC20 {
    constructor() ERC20("MyraCoin", "MMCC") {
        _mint(msg.sender, 100*10**18);
    }
    
}

/*
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

//LAZY CAPPED SUPPLY
//To use a lazy capped system, we need to inherit from ERC20Capped.sol contract
//ERC20Capped includes ERC20 methods as well. Therefore we can use ERC20 methods as well, we do not need inherit from it separetely.
contract MalmoToken3 is ERC20Capped {
    constructor(uint cap) ERC20("MalmoToken3", "MMT") ERC20Capped(cap){}

    function getTokens3() external {
        _mint(msg.sender, 1000*10**18);
    }
}
*/