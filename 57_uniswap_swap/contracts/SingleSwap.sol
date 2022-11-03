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
    //GOERLI VERSIONS:
    address public constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    address public constant LINK = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address public constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;

    IERC20 public usdcToken = IERC20(USDC);


    ISwapRouter public immutable swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    uint24 public constant poolFee = 3000;

    function swapExactInputSingle(uint amountIn) external returns(uint amountOut) {
        //we need to approve swapRouter so that it can withdraw amount from this contract. because later it will change it to another currency
        //instead of "address(swapRouter)" I can use swapRouter I guess
        usdcToken.approve(address(swapRouter), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: WETH,
            fee: poolFee,
            recipient: 0x547Fdf051df6454322cb7100A4d8edDE8B17a45E,
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
            recipient: 0x547Fdf051df6454322cb7100A4d8edDE8B17a45E,
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

    function destroy() external {
        selfdestruct(payable(0x547Fdf051df6454322cb7100A4d8edDE8B17a45E));
    }
}
