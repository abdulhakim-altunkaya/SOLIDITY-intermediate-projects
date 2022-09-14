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

    /* sender: the address that triggered the transaction
    amountToken: the amount borrowed (same as _amount0)
    _amount0 = the amount borrowed (same as amountToken)
    address[] = address that we will use to complete transaction
    token0: address of the first token (dai) on uniswap liq pool
    token1: address of the second token (eth) on uniswap liq pool
    IERC20 token: a pointer to the token that we will sell on sushiswap
    amountRequired: the amount of token that must be reimbursed to uniswap (??? is this not borrowed amount?)
    */
    function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external {
        address[] memory path = new address[](2);
        uint amountToken = _amount == 0 ? _amount1 : _amount0;
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        require(msg.sender == UniswapV2Library.pairFor(factory, token0, token1), "unauthorized");
        require(_amount0 == 0 || _amount1 == 0);
        path[0] = _amount0 == 0 ? token1 : token0;
        path[1] = _amount1 == 0 ? token0 : token1;
        IERC20 token = IERC20(_amount0 == 0 ? token1 : token0);
        token.approve(address(sushiRouter), amountToken);
        uint amountRequired = UniswapV2Library.getAmountsIn(factory, amountToken, path)[0];
        uint amountReceived = sushiRouter.swapExactTokensForTokens(amountToken, amountRequired, path, msg.sender, deadline)[1];
        IERC20 otherToken = IERC20(_amount0 == 0 ? token0 : token1);
        otherToken.transfer(msg.sender, amountRequired); //reimburse loan
        otherToken.transfer(tx.origin, amountReceived - amountRequired);  
    }
}