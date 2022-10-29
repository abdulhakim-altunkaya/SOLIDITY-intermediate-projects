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
    function depositToken(uint _amount) external;
    function depositBaseToken(uint _amount) external;
    function buyToken() external;
    function sellToken() external;
}

contract Arbitrage is FlashLoanSimpleReceiverBase {
    address payable public owner;
    error NotOwner(string message, address caller);
    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwner("you are not owner", msg.sender);
        }
        _;
    }

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    IDex public dexContract;
    address public dexAddress;
    function setContract(address _contractAddress) external {
        dexContract = IDex(_contractAddress);
        dexAddress = _contractAddress;
    }

    IERC20 public token;
    function setToken(address _tokenAddress) external {
        token = IERC20(_tokenAddress);
    }

    IERC20 public baseToken;
    function setBaseToken(address _baseTokenAddress) external {
        baseToken = IERC20(_baseTokenAddress);
    }

    function executeOperation(
        address asset,
        uint amount,
        uint premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        //This contract now has the funds. Arbitrage operation::
        dexContract.depositBaseToken(1000000000);
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

    function requestFlashLoan(address _tokenAddress, uint _amount) public {
        address receiverAddress = address(this);
        address asset = _tokenAddress;
        uint amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function approveBaseToken(uint _amount) external returns(bool) {
        return baseToken.approve(dexAddress, _amount);
        //approve(spender, amount)
    }

    function approveToken(uint _amount) external returns(bool) {
        return token.approve(dexAddress, _amount);
    }

    function allowanceBaseToken() external view returns(uint) {
        //allowance(owner, spender)
        return baseToken.allowance(address(this), dexAddress);
    }

    function allowanceToken() external view returns(uint) {
        return token.allowance(address(this), dexAddress);
    }

    function getBalance(address _tokenAddress) external view returns(uint) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress, uint _amount) external {
        IERC20 tokkie = IERC20(_tokenAddress);
        tokkie.transfer(msg.sender, _amount);
        //trasnfer(receiver, amount);
    }

    receive() external payable{}
}