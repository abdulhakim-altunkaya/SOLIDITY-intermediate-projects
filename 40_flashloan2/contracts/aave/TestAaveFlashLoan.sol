//SDPX-License-Identifier: MIT

pragma solidity >=0.8.1;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./FlashLoanReceiverBase.sol";

contract TestAaveFlashLoan is FlashLoanReceiverBase {

    using SafeMath for uint;

    constructor(ILendingPoolAddressesProvider _addressProvider) FlashLoanReceiverBase(_addressProvider) {

    }

    function testFlashLoan(address asset, uint amount) external {
        //balance inside the contract must be greater than the requested loan
        uint bal = IERC20(asset).balanceOf(address(this));
        require(bal > amount, "bal <= amount");

        //Lending_pool is a contract that is defined inside the receiverbase
        LENDING_POOL.flashLoan(
            receiver,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );

    }

    function executeOperation() external override returns(bool) {
        return true;
    }
}