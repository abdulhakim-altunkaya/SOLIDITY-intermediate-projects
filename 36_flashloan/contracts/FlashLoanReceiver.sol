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
     */
    
    FlashLoan public pool;
    address public owner;


    constructor(address _poolAddress) {
        pool = FlashLoan(_poolAddress);
        owner = msg.sender;
    }
}