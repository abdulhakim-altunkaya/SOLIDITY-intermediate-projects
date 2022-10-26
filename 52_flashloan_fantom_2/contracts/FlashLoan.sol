//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoan  is FlashLoanSimpleReceiverBase {
    error NotOwner(string message, address caller);    
    address payable public owner;
    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwner("you are not owner", msg.sender);
        }
        _;
    }

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    function executeOperation(
        address asset,
        uint amount,
        uint premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        uint amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        //approve(spender,amount)
        return true;
    }

    function requestFlashLoan(address _token, uint _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;
        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }
    
    //for 18 decimals coins. If you plan to use 6 decimals coins such as usdt/usdc, modify function below accordingly
    function getBalance(address tokenAddress) external view returns(uint) {
        uint balance = IERC20(tokenAddress).balanceOf(address(this));
        return balance/(10**18);
    }

    function withdraw(address _tokenAddress, uint _amount) external {
        IERC20 tokkie = IERC20(_tokenAddress);
        tokkie.transfer(msg.sender, _amount);
    }
    receive() external payable {}
}