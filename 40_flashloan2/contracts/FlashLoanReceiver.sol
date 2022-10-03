// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./FlashLoan.sol";

contract FlashLoanReceiver {
    FlashLoan public pool;

    address public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    event LoanReceived(address token, uint amount);

    constructor() {
        pool = FlashLoan(0x8EEdA66fAC8e128f03e01C7511070C92402Ad254);
        owner = msg.sender;
    }

    function receiveTokens(address _tokenAddress, uint _amount) external {
        require(msg.sender == address(pool), "only pool can call this function");
        require(Token(_tokenAddress).balanceOf(address(this)) == _amount, "receive xxx");
        emit LoanReceived(_tokenAddress, _amount);
        //do stuff with the money
        //return funds to the pool
        require(Token(_tokenAddress).transfer(msg.sender, _amount), "transfer funds back");
    }

    function executeFlashLoan(uint _amount) external onlyOwner {
        pool.flashLoan(_amount);
    }
}
