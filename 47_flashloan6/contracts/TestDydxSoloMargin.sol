// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

import "./interfaces/DydxFlashloanBase.sol";
import "./interfaces/ICallee.sol";

contract TestDydxSoloMargin is ICallee, DydxFlashloanBase {
    address private constant SOLO = 0x1E0447b19BB6EcFdAe1e4AE1694b0C3659614e4e;

    address public flashUser;

    event Log(string message, uint val);

    struct MyCustomData {
        address token;
        uint repayAmount;
    }

    function initiateFlashloan(address _token, uint _amount) external {
        //solo is the Dydx contract that we will be calling to get a flashloan
        ISoloMargin solo = ISoloMargin(SOLO);
        //We need the id of the token that we will be borrowing.
        //WETH: 0, SAI: 1, USDC: 2, DAI: 3
        uint marketId = _getMargetIdFromTokenAddress(SOLO, _token);

        //1.calculate amount+fee  (fee is generally 2 wei)
        //2.approve the solo contract to use the repayment amount from this contract.
        uint repayAmount = _getRepaymentAmountInternal(_amount);
        IERC20(_token).approve(SOLO, repayAmount);
        //flashloan in DYDX has 3 steps: withdraw, callFunction, deposit back
        Actions.ActionArgs[] memory operations = new Actions.ActionArgs[](3);
        operations[0] = _getWithdrawAction(marketId, _amount);
        operations[1] = _getCallAction(abi.encode(
            MyCustomData({token: _token, repayAmount: repayAmount})
        ));
        operations[2] = _getDepositAction(marketId, repayAmount);

        Account.Info[] memory accountInfos = new Account.Info[](1);
        accountInfos[0] = _getAccountInfo();

        solo.operate(accountInfos, operations);
    }

    function callFunction(address sender, Account.Info memory account, bytes memory data) public override {
        require(msg.sender == SOLO, "you are not solo");
        require(sender == address(this), "not this contract");
        //mcd: my custom data
        MyCustomData memory mcd = abi.decode(data, (MyCustomData));
        uint repayAmount = mcd.repayAmount;
        //making sure we have enough to repay
        uint bal = IERC20(mcd.token).balanceOf(address(this));
        require(bal >= repayAmount, "bal < repay");
        //some custom code:
        flashUser = sender;
        emit Log("bal", bal);
        emit Log("repay", repayAmount);
        emit Log("bal - repay", bal - repayAmount);

    }
}