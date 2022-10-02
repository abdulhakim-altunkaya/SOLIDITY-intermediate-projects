// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./FlashLoan.sol";

contract FlashLoanReceiver {
    /*1. step: save deployed pool contract as an instance inside a variable
    FlashLoan public pool;
    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
    }
    2.step
    create an owner and make it equal to msg.sender

    3.step
    call the flashloan function of the pool contract to receive some tokens
     */
    
    FlashLoan public pool;
    address public owner;

    event LoanReceived(address token, uint amount);

    modifier onlyOwner(){
        require(msg.sender == owner, "you arent owner");
        _;
    }

    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
        owner = msg.sender;
    }

    //only the pool can call this function after sending tokens to the receiver
    function receiveTokens(address _tokenAddress, uint _amount) external {
        require(msg.sender == address(pool), "only pool can call this function");
        require(Token(_tokenAddress).balanceOf(address(this)) == _amount, "receiveTokens function");
        emit LoanReceived(_tokenAddress, _amount);

        // do stuff with the money

        // return funds to the pool
        require(Token(_tokenAddress).transfer(msg.sender, _amount), "transfer funds back");
    }

    //3.step
    function executeFlashLoan(uint _amount) external onlyOwner {
        pool.flashLoan(_amount);
    }
}