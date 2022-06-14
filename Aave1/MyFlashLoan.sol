pragma solidity ^0.6.6;

import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/FlashLoanReceiverBase.sol";
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPoolAddressesProvider.sol";
import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPool.sol";

contract Flashloan is FlashLoanReceiverBase {
    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    // Rest of your code goes here
}