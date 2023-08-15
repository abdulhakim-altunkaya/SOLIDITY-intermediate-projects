//SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

/*TokenA contract is an erc20 token contract. */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract TokenA is ERC20Capped {


    constructor(uint _cap) ERC20("TokenA", "TOKA") ERC20Capped(_cap*(10**18)) {
    }

    //minting function for owner, free minting for testing purposes, decimals handled, 10000 is arbitrary
    function mintOwner(uint _amount) external {
        require(_amount > 0 && _amount < 10000, "mint between 0 and 10000");
        _mint(msg.sender, _amount*(10**18));
    }

    function getYourBalance() external view returns(uint) {
        return balanceOf(msg.sender) / (10**18);
    }
    function getContractBalance() external view returns(uint) {
        return balanceOf(address(this)) / (10**18);
    }
    function getAnyBalance(address _anyAddress) external view returns(uint) {
        return balanceOf(_anyAddress) / (10**18);
    }

}