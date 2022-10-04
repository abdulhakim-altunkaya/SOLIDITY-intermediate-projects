// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./FlashLoan.sol";
import "./IERC20.sol";

contract FlashLoanReceiver3 {
    FlashLoan public pool;

    event LoanReceived(address token, uint amount);

    constructor() {
        pool = FlashLoan(0x8EEdA66fAC8e128f03e01C7511070C92402Ad254);
    }

    

    function receiveTokens(address asset, uint _amount) external {
        require(msg.sender == address(pool), "only pool can call this function");
        require(IERC20(asset).balanceOf(address(this)) == _amount, "receive xxx");
        emit LoanReceived(asset, _amount);
        //do stuff with the money
        //return funds to the pool
        require(IERC20(asset).transfer(msg.sender, _amount), "transfer funds back");
    }

    function executeFlashLoan(uint _amount) external  {
        pool.flashLoan(_amount);
    }
}
