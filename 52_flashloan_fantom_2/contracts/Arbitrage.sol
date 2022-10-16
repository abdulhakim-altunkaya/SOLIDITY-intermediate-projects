//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

interface IDEX {
    function depositUSDC(uint _amount) external;
    function depositDAI(uint amount) external;
    function buyDAI() external;
    function sellDAI() external;
}

contract Arbitrage is FlashLoanSimpleReceiverBase {
    address payable public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    IERC20 private constant dai = IERC20(0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02);
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IDEX private constant dex = IDEX(0xC9F1a0063E824e178486456f4e4f7EB70652e38B);

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = msg.sender;
    }

    //This function will be called after your contract receives flashloan
    function executeOperation(
        address asset,
        uint amount,
        uint fee,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        // This contract now has the funds requested.
        // Arbirtage operation
        dexContract.depositUSDC(1000000000); //100 usdc
        dexContract.buyDAI();
        dexContract.depositDAI(dai.balanceOf(address(this)));
        dexContract.sellDAI();
        // At the end of your logic above, this contract owes
        // the flashloaned amount + premiums.
        // Therefore ensure your contract has enough to repay these amounts.
        // Approve the Pool contract allowance to *pull* the owed amount
        uint amountOwed = amount + fee;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }

    function requestFlashloan(address _token, uint _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint amount = _amount;
        bytes memory params = "";
        uint referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }

    function approveUSDC(uint _amount) external returns(bool) {
        return usdc.approve(dexContractAddress, _amount);
    }

    function allowanceUSDC() external view returns(uint) {
        return usdc.allowance(address(this), dexContractAddress);
    }

    function approveDAI(uint _amount) external returns(bool) {
        return dai.approve(dexContractAddress, _amount);
    }

    function allowanceDAI() external view returns(uint) {
        return dai.allowance(address(this), dexContractAddress);
    }

    function getBalance(address _tokenAddress) external view returns(uint) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address tokenAddress) external {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
    receive() external payable {}

}