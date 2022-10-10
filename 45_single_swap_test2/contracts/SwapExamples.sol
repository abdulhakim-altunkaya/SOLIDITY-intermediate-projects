//SPDX-License-Identifier: MIT

pragma solidity >=0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SwapExamples {
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    //POLYGON:  address public constant ETH = 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619;
    // POLYGON: address public constant USDC = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
    address public constant WMATIC = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;

    // For this example, we will set the pool fee to 0.3%.
    uint24 public constant poolFee = 3000;

    /*We will use exactInput and exactOutput functions. For both of them, we must approve swapRouter address first.
    swapExactInputSingle swaps a fixed amount of WETH9 for a maximum possible amount of DAI
    using the DAI/WETH9 0.3% pool by calling `exactInputSingle` in the swap router.
    The calling address must approve this contract to spend at least `amountIn` worth of its DAI for this function to succeed.
    amountIn The exact amount of WETH9 that will be swapped for DAI.
    amountOut The amount of DAI received.*/
    function swapExactInputSingle(uint amountIn) external returns(uint amountOut) {
        //TransferHelper.safeTransferFrom(token, from, to, value);
        //Transfer specified amount of weth9 to this contract. Because we will change weth to dai.
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        //approve the router to spend the weth
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: DAI,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }

    //Convert exact 1 weth to USDC
    function exactInputUSDC(uint amountIn) external returns(uint amountOut) {
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WETH9,
            tokenOut: USDC,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    } 



    /*swapExactOutputSingle swaps a minimum possible amount of WETH for a fixed amount of DAI.
    The calling address must approve this contract to spend its WETH for this function to succeed. As the amount of input DAI is variable,
    the calling address will need to approve for a slightly higher amount, anticipating some variance.
    amountOut The exact amount of DAI to receive from the swap.
    amountInMaximum The amount of WETH we are willing to spend to receive the specified amount of DAI.
    amountIn The amount of WETH actually spent in the swap.*/
    function swapExactOutputSingle(uint amountOut, uint amountInMaximum) external returns(uint amountIn) {
        //transfer the specified amount of weth to this contract.
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountInMaximum);
        //approve the swapRouter to spend the specified amount of `amountInMaximum` of WETH.
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
                tokenIn: WETH9,
                tokenOut: DAI,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
        });
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(WETH9, address(swapRouter), 0);
            TransferHelper.safeTransfer(WETH9, msg.sender, amountInMaximum - amountIn);
        }
    }
    /*
    //Convert exact 1 WMATIC to USDC
    function exactInputWMATIC(uint amountIn) external returns(uint amountOut) {
        TransferHelper.safeTransferFrom(ETH, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(ETH, address(swapRouter), amountIn);
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: ETH,
            tokenOut: USDC,
            fee: poolFee,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });
        // The call to `exactInputSingle` executes the swap.
        amountOut = swapRouter.exactInputSingle(params);
    }
    */

}