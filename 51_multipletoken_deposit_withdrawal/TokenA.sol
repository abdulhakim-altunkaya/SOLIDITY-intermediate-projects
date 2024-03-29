// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./helpers/ERC20.sol";
import "./helpers/ERC20Capped.sol";

contract TokenA is ERC20Capped {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    constructor(uint cap) ERC20("TokenA", "AAAAA") ERC20Capped(cap * (10**18)) {
        owner = msg.sender;
    }

    function mintTokens(address to, uint amount) external {
        uint amount2 = amount * (10**18);
        _mint(to, amount2);
    }

    function burnTokens(uint amount) external {
        uint amount2 = amount * (10**18);
        _burn(msg.sender, amount2);
    }

    function approvePool(address pool, uint amount) external {
        uint amount2 = amount * (10**18);
        approve(pool, amount2);
    }

}
