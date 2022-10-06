// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./Pool.sol";
import "./IERC20.sol";

contract UniswapFlashSwap {

    Pool public pool;

    event LoanReceived(address token, uint amount);

    constructor() {
        pool = Pool(0x8d5D1f79868E69CdCf7c4116589f9B48A09AdaEf);
    }

    function uniswapV2Call(address asset, uint _amount) external {
        require(msg.sender == address(pool), "only pool can call this function");
        require(IERC20(asset).balanceOf(address(this)) == _amount, "receive blabla");
        emit LoanReceived(asset, _amount);
        //do stuff with the money
        //return funds to the pool
        require(IERC20(asset).transfer(msg.sender, _amount), "transfer funds back");
    }
    function flashSwap(uint _amount) external  {
        pool.swap(_amount);
    }


}

