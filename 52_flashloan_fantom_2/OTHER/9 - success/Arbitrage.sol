
//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/*
https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol
https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol
https://github.com/aave/aave-v3-core/blob/master/contracts/dependencies/openzeppelin/contracts/IERC20.sol
*/

interface IDex {
    function depositDAI(uint amount) external;
    function depositUSDC(uint amount) external;
    function depositUSDT(uint amount) external;
    function buyDAI() external;
    function sellDAI() external;
    function buyUSDT() external;
    function sellUSDT() external;
}

contract Arbitrage is FlashLoanSimpleReceiverBase {
    address payable public owner;
    modifier onlyOwner(){
        require(msg.sender == owner, "you are not owner");
        _;
    }
    IERC20 private constant dai = IERC20(0xAC1a9503D1438B56BAa99939D44555FC2dC286Fc);
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 private constant usdt = IERC20(0x1b901d3C9D4ce153326BEeC60e0D4A2e8a9e3cE3);
    IDex private constant dexContract = IDex(0xA41c391477B32EDbcB48C4EdE568270D6b257FE4);
    address private immutable dexAddress = 0xA41c391477B32EDbcB48C4EdE568270D6b257FE4;

    constructor(address addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(addressProvider)) {
        owner = payable(msg.sender);
    }

    function executeOperation(
        address asset,
        uint amount,
        uint premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        //This contract now has the funds. Arbitrage operation:
        dexContract.depositUSDC(1000000000);
        dexContract.buyDAI();
        dexContract.depositDAI(dai.balanceOf(address(this)));
        dexContract.sellDAI();
        // At the end of your logic above, this contract owes the flashloaned amount + premiums.
        // Therefore ensure your contract has enough to repay these amounts.
        // Approve the Pool contract allowance to *pull* the owed amount
        uint amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }

    /*
    function executeOperation(
        address asset,
        uint amount,
        uint premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        //This contract now has the funds. Arbitrage operation:
        dexContract.depositUSDC(1000000000);
        dexContract.buyUSDT();
        dexContract.depositUSDT(usdt.balanceOf(address(this)));
        dexContract.sellUSDT();
        // At the end of your logic above, this contract owes the flashloaned amount + premiums.
        // Therefore ensure your contract has enough to repay these amounts.
        // Approve the Pool contract allowance to *pull* the owed amount
        uint amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }
    */
    function requestFlashLoan(address token, uint _amount) public {
        address receiverAddress = address(this);
        address asset = token;
        uint amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function approveUSDC(uint amount) external returns(bool) {
        return usdc.approve(dexAddress, amount);
    }
    function allowanceUSDC() external view returns(uint) {
        return usdc.allowance(address(this), dexAddress);
    }
    function approveDAI(uint amount) external returns(bool) {
        return dai.approve(dexAddress, amount);
    }
    function allowanceDAI() external view returns(uint) {
        return dai.allowance(address(this), dexAddress);
    }
    function approveUSDT(uint amount) external returns(bool) {
        return usdt.approve(dexAddress, amount);
    }
    function allowanceUSDT() external view returns(uint) {
        return usdt.allowance(address(this), dexAddress);
    }

    function getBalance(address tokenAddress) external view returns(uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
    function withdraw(address tokenAddress, uint amount) external {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }
    receive() external payable{}
}