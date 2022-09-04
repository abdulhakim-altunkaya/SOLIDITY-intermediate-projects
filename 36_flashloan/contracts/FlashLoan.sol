// SPDX-License-Identifier: AGPL-3.0

pragma solidity >=0.8.10;

import './FlashLoanReceiverBase.sol';
import "./FlashLoanSimpleReceiverBase.sol";
import "./IPoolAddressesProvider.sol";
import "./IPool.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {

    constructor(IPoolAddressesProvider provider) FlashLoanSimpleReceiverBase(provider){}
    function aaveFlashloan(address loanToken, uint256 loanAmount) external {
        IPool(address(POOL)).flashLoanSimple(address(this), loanToken, loanAmount, "0x", 0);
    }
}