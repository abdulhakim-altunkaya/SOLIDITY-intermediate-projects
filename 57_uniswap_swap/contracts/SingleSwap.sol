// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
pragma abicoder v2; 

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

interface IERC20 {
    function transfer(address recipient, uint amount) external returns(bool);
    function approve(address spender, uint amount) external returns(bool);
    function balanceOf(address account) external view returns(uint);
}

contract SingleSwap {
    address public constant USDC = 0xe11A86849d99F524cAC3E7A0Ec1241828e332C62;
    address public constant LINK = "";
    address public constant WETH = 0xA6FA4fB5f76172d178d61B04b0ecd319C5d1C0aa;
    IERC20 public usdcToken = IERC20(USDC)

    address public constant routerAddress = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable swapRouter = ISwapRouter(routerAddress);
    uint24 public constant poolFee = 3000;

    function swapExactInputSingle(uint amountIn) external returns(uint amountOut) {
        //we need to approve swaprouter to withdraw the amount from this contract so that it will change it to another currency
        usdcToken.approve(address(swapRouter), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: WETH,
            fee: poolFee,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(uint amountOut, uint amountInMaximum) external returns(uint amountIn) {
        usdcToken.approve(address(swapRouter), amountInMaximum);
        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: USDC,
            tokenOut: WETH,
            fee: poolFee,
            recipient: address(this),
            deadline: block.timestamp,
            amountOut: amountOut,
            amountInMaximum: amountInMaximum,
            sqrtPriceLimitX96: 0
        });
        amountIn = swapRouter.exactOutputSingle(params);
        if(amountIn < amountInMaximum) {
            usdcToken.approve(address(swapRouter), 0);
            usdcToken.transfer(address(this), amountInMaximum - amountIn);
        }
    }

    function getBal18(address _tokenAddress) external view returns(uint) {
        uint balance = IERC20(_tokenAddress).balanceOf(address(this));
        return balance / (10**18);
    }
    function getBal6(address _tokenAddress) external view returns(uint) {
        uint balance = IERC20(_tokenAddress).balanceOf(address(this));
        return balance / (10**6);
    }

    function destroyContract() external {
        selfdestruct(msg.sender);
    }
}
