//SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

/*TokenA contract is an erc20 token contract. We will use TokenA as our pool token. In reality, 
this can be WETH, WBTC, WBNB or any other token. People will deposit their TokenA into the FoggyBank
anonymously and later they will withdraw anonymously. */

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

    uint public fee = 1 ether;


    //contrct --> ccount
    function collectFees() external {
        uint balanceFoggy = balanceOf(address(this));
        if (balanceFoggy > 0) {
            _transfer(address(this), msg.sender, balanceFoggy);
        }
    }

    // ccount --> contrct
    //approve FoggyBank contract before sending tokens to it
    function approveFoggyBank(address _contractFoggyBank, uint _amount) external {
        require(_amount > 0, "approve amount must be greater than 0");
        uint amount = _amount*(10**18);
        _approve(msg.sender, _contractFoggyBank, amount);
        IERC20(address(this)).transferFrom(msg.sender, address(this), amount);
    }

    function addLiquidityTokenA(uint _amount) external {
        IERC20(address(this)).transferFrom(msg.sender, address(this), _amount);
    }

}