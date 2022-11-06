//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable public owner;
    error NotOwner(string message, address caller);
    modifier onlyOwner(){
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

    function getBal18(address _tokenAddress) external view returns(uint) {
        uint balance = IERC20(_tokenAddress).balanceOf(address(this));
        return balance / (10**18);
    }
    function getBal6(address _tokenAddress) external view returns(uint) {
        uint balance = IERC20(_tokenAddress).balanceOf(address(this));
        return balance / (10**6);
    }

    function withdraw(address _tokenAddress, uint _amount) external {
        IERC20 tokkie = IERC20(_tokenAddress);
        tokkie.transfer(msg.sender, _amount);
    }

    receive() external payable{}

}