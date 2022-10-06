// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./ERC20.sol";
import "./ERC20Capped.sol";

contract Token is ERC20Capped {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    constructor(uint cap) ERC20("Hardworking", "HARDY") ERC20Capped(cap * (10**18)) {
        owner = msg.sender;
    }

    function mintTokens(address to, uint amount) external {
        uint amount2 = amount * (10**18);
        _mint(to, amount2);
    }

    function burnTokens(uint amount) external {
        _burn(msg.sender, amount);
    }

}
