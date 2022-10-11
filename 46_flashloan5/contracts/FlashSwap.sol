//SPDX-License-Identifier: MIT

pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IUniswapV2Callee {
    //uniswap will call this function
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

contract TestUniswapFlashSwap is IUniswapV2Callee {
    //we will call this function. This function will call flashloan function on uniswap.
    function testFlashSwap(address _tokenBorrow, uint _amount) external {

    }

    //after above step, uniswap will call this function on our contract.
    function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external override {

    }
}

