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

        address receiver = address(this);

        //we want to borrow only 1 asset
        address[] memory assets =  new address[](1);
        assets[0] = asset;

        uint[] memory amounts = new uint[](1);
        amounts[0] = amount;

        //0=no debt/paid all loan, 1=stable, 2=variable
        uint[] memory modes = new uint[](1);
        modes[0] = 0;

        //in case the mode is 1 or 2, we will need another contract to receive the loan
        address onBehalfOf = address(this);

        //we dont have any other params that we want to pass, so it is empty
        bytes memory params = ""; //use abi.encode()

        //we dont have a referral code
        uint16 referralCode = 0;

        //Lending_pool is a contract that is defined inside the receiverbase
        LENDING_POOL.flashLoan(
            receiver, //address of the contract that is going to receive the loan whic is this contract
            assets, //array of tokens that we want to borrow
            amounts, // amount of token that we want to borrow
            modes, // status of this contract
            onBehalfOf, // 
            params, // If you any other params that you want to pass over executeoperation
            referralCode //
        );

    }

    function executeOperation(
        address[] calldata assets,
        uint[] calldata amounts,
        uint[] calldata premiums, //the fee that we need to pay
        address initiator, //the address that executed the flashloan
        bytes calldata params
    ) external override returns(bool) {
        //do stuff here..arbitrage, liquidation, ???
        //repay Aave

        for(uint i=0; i<assets.length; i++) {
            emit Log("borrowed", amounts[i]);
            emit Log("fee", premiums[i]);

            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
    }
}