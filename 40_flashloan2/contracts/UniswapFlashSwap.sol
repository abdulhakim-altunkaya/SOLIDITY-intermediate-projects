//SPDX-License-Identifier: MIT

pragma solidity >=0.8.1;

import "./IERC20.sol";
import "./IUniswapV2Router.sol";


interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

//We are inheriting from interface, so we must implement uniswapV2Call function
contract UniswapFlashSwap is IUniswapV2Callee {

    //address of the token we want to borrow
    address private constant WETH = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    // address of Uniswap V2 factory:
    address private constant FACTORY = 0x1F98431c8aD98523631AE4a59f267346ea31F984;

    event Log(string message, uint val);

    //We will call this function
    function testFlashSwap(address _tokenBorrow, uint _amount) external {
        //checking if parent contract for _tokenBorrow and WETH exists ???
        address pair = IUniswapV2Factory(FACTORY).getPair(_tokenBorrow, WETH);
        require(pair != address(0), "there is no pair");
        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();
        uint amount0Out = _tokenBorrow == token0 ? _amount : 0;
        uint amount1Out = _tokenBorrow == token1 ? _amount : 0;

        bytes memory data = abi.encode(_tokenBorrow, _amount);
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);

    }

    //Uniswap will call this function
    function uniswapV2Call(address _sender, uint _amount0, uint _amount1, bytes calldata _data) external override {
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();
        address pair = IUniswapV2Factory(FACTORY).getPair(token0, token1);
        require(msg.sender == pair, "only pool contract can call this");
        require(_sender == address(this), "sender must be receiver");
        (address tokenBorrow, uint amount) = abi.decode(_data, (address, uint));

        uint fee = ((amount * 3) / 997) + 1;
        uint amountToPay = amount+fee;

        emit Log("amount", amount);
        emit Log("amount0", _amount0);
        emit Log("amount1", _amount1);
        emit Log("fee", fee);
        emit Log("amount to pay back", amountToPay);

        IERC20(tokenBorrow).transfer(pair, amountToPay);
    }

}
