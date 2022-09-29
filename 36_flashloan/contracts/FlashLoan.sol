// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";


//this is flashloan pool contract. In reality, you wont need this, because
//pools and their token address will be readily available by dexes.
contract FlashLoan {

    Token public token;

    //this is to track pool balance.
    uint public poolBalance;

    constructor(address _tokenAddress){
        token = Token(_tokenAddress);
    }

    //this is a great function. It shows to to deposit erc20 tokens inside any contract.
    //I need to check if we will need to approve this contract before transferring.
    // Also search for call option. 
    function depositTokens(uint _amount) external  {
        require(_amount > 0, "you must deposit more than 0");
        token.transferFrom(msg.sender, address(this), _amount);
        poolBalance = poolBalance + _amount;
    }

    function flashloan(uint _borrowAmount) external {

    }


}