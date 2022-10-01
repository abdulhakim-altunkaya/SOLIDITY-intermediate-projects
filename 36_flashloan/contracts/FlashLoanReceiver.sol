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

    modifier onlyOwner(){
        require(msg.sender == owner, "you arent owner");
        _;
    }

    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
        owner = msg.sender;
    }

    //3.step
    function executeFlashLoan(uint _amount) external onlyOwner {
        pool.flashLoan(_amount);
    }
}