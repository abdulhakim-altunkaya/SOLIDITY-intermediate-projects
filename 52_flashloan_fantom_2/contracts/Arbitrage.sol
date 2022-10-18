//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IDex {
    function depositUSDC(uint _amount) external;
    function depositDAI(uint _amount) external;
    function buyDAI() external;
    function sellDAI() external;
}

contract Arbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    address private immutable daiAddress = 0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02;
    address private immutable usdcAddress = 0x06f0790c687A1bED6186ce3624EDD9806edf9F4E;
    address private immutable dexAddress = 0x7b25b45D11e3f7c39959C96324aD765a73081867;

    IERC20 private dai;
    IERC20 private usdc;
    IDex private dexContract;

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
        dexContract = IDex(dexAddress);
    }
    //this function is called after your contract receives flashloan
    function executeOperation(
        address asset, 
        uint amount, 
        uint premium, 
        address initiator, 
        bytes calldata params
    ) external override returns (bool) {
        //this contract now has the funds.
        //arbitrage operation:
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
    function requestFlashLoan(address _token, uint _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
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
    function allowanceDAI() external view returns(bool) {
        return dai.allowance(address(this), dexAddress);
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