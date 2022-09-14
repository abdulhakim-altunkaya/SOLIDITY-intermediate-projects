pragma solidity ^0.6.6;

import './UniswapV2Library.sol';
import './interfaces/IUniswapV2Router02.sol';
import './interfaces/IUniswapV2Pair.sol';
import './interfaces/IUniswapV2Factory.sol';
import './interfaces/IERC20.sol';

/*
Buy 2m dai on uniswap
Exchange 2m to 10000 eth on uniswap
transfer 10000 eth to sushiwap
exchange 10000 eth to dai on sushiswap
transfer new dai amount from sushi to uniswap
pay 0.3 commission and loan back to uniswap
pocket the difference */

contract Arbitrage {
    //information provider about the pools in Uniswap
    address public factory;

    //The date the trade is due(? not sure what does this mean)
    uint constant deadline = 10 days;

    //The smart contract of Sushiswap that lets people to trade in its liq pools
    IUniswapV2Router02 public sushiRouter;

    constructor(address _factory, address _sushiRouter) public {
        factory = _factory;
        sushiRouter = IUniswapV2Router02(_sushiRouter);
    }

    /*token0: the token we are going to borrow(dai)
    token1: the token we are goint to trade(eth)
    amount0: the amount of loan (dai)
    amount1: this will be 0
    pairAddress: the address of the liq pool of uniswap*/
    function startArbitrage(address token0, address token1, uint amount0, uint amount1) external {
        address pairAddress = IUniswapV2Factory(factory).getPair()
        require(pairAddress != address(0), "no such pool");
        IUniswapV2Pair(pairAddress).swap(amount0, amount1, address(this), bytes("not empty"))
    }

}