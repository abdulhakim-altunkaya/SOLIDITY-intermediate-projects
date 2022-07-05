//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

//LAZY UNCAPPED SUPPLY
contract GladCoin is ERC20 {
    constructor() ERC20("GladCoin", "GLAD") {}

    function mintTokens() external {
        _mint(msg.sender, 10*10**18);
    }
    // spender and recipient : contract
    // owner and sender :  msg.sender
    function promtAccess1(address spender, uint amount) external {
        approve(spender, amount);
    }

    function promtAccess2(address spender, uint amount) external {
        approve(spender, amount);
        _approve(msg.sender, spender, amount);
    }

    function promtAccess3(address spender, uint amount) external {
        _approve(msg.sender, spender, amount);
    }

    function promtAccess4(address spender, uint amount) external {
        _approve(msg.sender, spender, amount);
        allowance(msg.sender, spender);
    }

    function promtAccess5(address spender) external view {
        allowance(msg.sender, spender);
    }

    function promtAccess6(address recipient, uint amount) external {
        transferFrom(msg.sender, recipient, amount);
    }

}

