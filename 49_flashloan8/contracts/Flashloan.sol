//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

//first import is needed to make our contract being able to receive a loan 

contract Flashloan is FlashLoanSimpleReceiverBase {
    address payable public owner;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function executeOperation(
            address asset, 
            uint amount, 
            uint fee, 
            address initiator, 
            bytes calldata params
            ) 
            external override returns(bool) {
            uint amountOwed = amount + fee;
            //addressPOOL is the spender
            IERC20(asset).approve(address(POOL), amountOwed);
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

    function getBalance(address _tokenAddress) external view returns(uint) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }
/*
    function withdraw(address receiver, address tokenAddress, uint amount) external {
        require(msg.sender == owner, "not owner");
        IERC20 token = IERC20(tokenAddress);
        (bool success, ) = receiver.call{value: token.balanceOf(address(this))}("");
        require(success, "withdrawal failed");
    }
*/

    
    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    receive() external payable {}
}