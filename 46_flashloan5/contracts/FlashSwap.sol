//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/IUniswapV2Router.sol";

interface IUniswapV2Callee {
    //uniswap will call this function
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

contract TestUniswapFlashSwap is IUniswapV2Callee {

    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    event Log(string message, uint val);

    //we will call this function. This function will call flashloan function on uniswap.
    function testFlashSwap(address _tokenBorrow, uint _amount) external {
        //we are calling getPair function on factory contract to 
        //get "tokenborrow and weth pair contract" address.
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenBorrow, WETH);
        //then we check to see the address data is not equal to zero.
        //if not zero address, then we know we can trade between weth and tokenborrow.
        require(pair != address(0), "!pair");

        //Inside the uniswappair contract, the two tokens we want to trade are named as 
        //token0 and token1. we dont know yet if tokenborrow is token0/token1 or if weth
        //is token0 or token1. So we use weird block below.
        //In any case, one of then will be _amount and the other one will be zero.
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint amount0Out = _tokenBorrow == token0 ? _amount : 0;
        uint amount1Out = _tokenBorrow == token1 ? _amount : 0;

        //the below function of uniswap is the same as regular swap. Uniswap determines
        //if this is a flashswap or regular swap by looking at the last parameter.
        //If it is empty (""), then it will be treated as regular swap. If not empty,
        //then it will be treated as flashswap. thats why we pass data parameter 
        // instead of ""
        bytes memory data = abi.encode(_tokenBorrow, _amount);
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);

    }

    //after above step, uniswap will call this function on our contract.
    function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external override {
        //we must make sure only pair contract can call this function.
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address pair = IUniswapV2Factory(FACTORY).getPair(token0, token1);
        require(msg.sender == pair, "!pair");
        //_sender will hold the address that initiated the flashloan
        require(_sender == address(this), "!sender");

        (address tokenBorrow, uint amount) = abi.decode(_data, (address, uint));

        uint fee = ((amount*3) / 997) + 1;
        uint amountToRepay = amount + fee;

        emit Log("amount", amount);
        emit Log("amount0", _amount0);
        emit Log("amount1", _amount1);
        emit Log("fee", fee);
        emit Log("amount to repay", amountToRepay);

        IERC20(tokenBorrow).transfer(pair, amountToRepay);
    }
}

