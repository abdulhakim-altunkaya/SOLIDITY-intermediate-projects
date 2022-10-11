//SPDX-License-Identifier: MIT

pragma solidity >=0.5.0;
import "https://github.com/aave/aave-protocol/blob/4b4545fb583fd4f400507b10f3c3114f45b8a037/contracts/lendingpool/LendingPool.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/configuration/LendingPoolAddressesProvider.sol";
import "https://github.com/aave/aave-protocol/blob/master/contracts/flashloan/base/FlashLoanReceiverBase.sol";


contract Borrower {
    LendingPoolAddressesProvider public provider;
    address dai;

    constructor(address _provider, address _dai) FlashLoanReceiverBase(_provider) {
        provider = LendingPoolAddressesProvider(_provider);
        dai = _dai;
    }

    function startLoan(uint amount, bytes calldata _params) external {
        LendingPool lendingPool = LendingPool(provider.getLendingPool());
        //lendingpool will send amount of dai to addressthis
        lendingPool.flashLoan(address(this), dai, amount, _params);
    }

    function executeOperation(address _reserve, uint _amount, uint _fee, bytes memory _params) {
        transferFundsBackToPoolInternal(_reserve, _amount + _fee );
    } 

}