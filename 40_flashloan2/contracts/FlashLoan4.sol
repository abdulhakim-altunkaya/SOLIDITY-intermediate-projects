// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./Token.sol";
import "./IERC20.sol";

/*This is to make sure all msg.sender of flashloan function, will have receiveTokens
function inside their contract as shown in the interface. */
interface IReceiver {
    function receiveTokens(address tokenAddress, uint amount) external;
}

//this is flashloan pool contract. In reality, you wont need this, because
//pools and their token address will be readily available by dexes.

//Our plan is to send some tokens from Token contract to this POOL contract.
//To do that, first deploy this contrac, then go to Token interface on mumbaiscan
//then first approve Pool contract and then send 1000000 token to Pool contract by using
//the depositTokens function below.

contract FlashLoan is ReentrancyGuard {
    Token public token;

    //To keep tranck of poolBalance.
    uint public poolBalance;

    constructor(){
        token = Token(0x05714B0c537E685dbe4E5Cda1E6CA934e40c0588);
    }

    function depositTokens(uint _amount) external nonReentrant {
        require(_amount > 0, "you need to deposit more than 0");
        token.transferFrom(msg.sender, address(this), _amount);
        poolBalance = poolBalance + _amount;
        //Cant i say poolBalance = address(this).balance ???
    }

    IERC20(Currencyx) public currencyx; 
    //send tokens to Receiver, then request it back
    function flashLoan(uint _borrowAmount) external nonReentrant {
        
        require(_borrowAmount > 0, "borrow amount cannot be 0");
        uint balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= _borrowAmount, "not enough funds");
        //Just to make sure pool is working and has funds
        assert(poolBalance == balanceBefore);
        //Transfer tokens to the Receiver
        token.transfer(msg.sender, _borrowAmount);
        //Receiver uses the funds
        //Later pool is requesting the loan back
        IReceiver(msg.sender).receiveTokens(address(token), _borrowAmount);
        //ensuring the loan is paid back
        uint balanceAfter = token.balanceOf(address(this));
        require(balanceAfter >= balanceBefore, "loan is not paid back");
    }
}


