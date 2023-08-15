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

    uint public fee = 3;

    //CONTRACT --> ACCOUNT
    function receiveTokens1() external {
        IERC20(address(this)).transfer(address(this), fee*(10**18));
    }

    //CONTRACT --> ACCOUNT
    function receiveTokens2() external {
        _transfer(address(this), msg.sender, fee*(10**18));
    }
    //CONTRACT --> ACCOUNT
    //this will give error because "_transfer" is in ERC20 but not in IERC20
    //Thats why above function will work, because this contract inheritss from ERC20Capped
    //but this one will not work as it is attempting to access it from IERC20
    //This same thing goes for "_approve"
    function receiveTokens3() external {
        IERC20(address(this))._transfer(address(this), msg.sender, fee*(10**18));
    }

    //ACCOUNT --> CONTRACT
    function makePayment1() external {
        require(balanceOf(msg.sender) >= fee*(10**18), "you don't have CONTOR");
        require(msg.sender == tx.origin, "contracts cannot withdraw");
        require(msg.sender != address(0), "real addresses can withdraw");
        _transfer(msg.sender, address(this), fee*(10**18));
    }

    //ACCOUNT --> CONTRACT
    function makePayment2() external {
        uint amount = fee*(10**18);
        _approve(msg.sender, address(this), amount);
        IERC20(address(this)).transferFrom(msg.sender, address(this), fee*(10**18));
    }
    //this doesnt work, it errors
    function makePayment3() external {
        uint amount = fee*(10**18);
        _approve(msg.sender, address(this), amount);
        transferFrom(msg.sender, address(this), fee*(10**18));
    }

}