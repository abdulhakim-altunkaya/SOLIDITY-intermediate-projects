
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
    function depositToken(uint amount) external;
    function depositUSDC(uint amount) external;
    function buyToken() external;
    function sellToken() external;
}

contract Arbitrage is FlashLoanSimpleReceiverBase {
    address payable public owner;
    modifier onlyOwner(){
        require(msg.sender == owner, "you are not owner");
        _;
    }
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 public token;
    function setToken(address _tokenAddress) external {
        token = IERC20(_tokenAddress);
    }
    IDex public dexContract;
    address public dexAddress;
    function setContract(address _dexAddress) external {
        dexContract = IDex(_dexAddress);
        dexAddress = _dexAddress;
    }


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
        dexContract.buyToken();
        dexContract.depositToken(token.balanceOf(address(this)));
        dexContract.sellToken();
        // At the end of your logic above, this contract owes the flashloaned amount + premiums.
        // Therefore ensure your contract has enough to repay these amounts.
        // Approve the Pool contract allowance to *pull* the owed amount
        uint amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }

    function requestFlashLoan(address _tokenA, uint _amount) public {
        address receiverAddress = address(this);
        address asset = _tokenA;
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
    function approveToken(uint amount) external returns(bool) {
        return token.approve(dexAddress, amount);
    }
    function allowanceToken() external view returns(uint) {
        return token.allowance(address(this), dexAddress);
    }

    function getBalance(address tokAddress) external view returns(uint) {
        return IERC20(tokAddress).balanceOf(address(this));
    }
    function withdraw(address tokAddress, uint amount) external {
        IERC20 tokkie = IERC20(tokAddress);
        tokkie.transfer(msg.sender, amount);
    }
    receive() external payable{}
}