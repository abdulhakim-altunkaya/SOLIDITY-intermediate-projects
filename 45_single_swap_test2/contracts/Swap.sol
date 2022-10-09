//SPDX-License-Identifier: MIT

pragma solidity >=0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SwapExamples {
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant WMATIC = 0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889;
    address public constant USDC = 0xe11a86849d99f524cac3e7a0ec1241828e332c62;
    address public constant USDC_YOUTUBE = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;



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
        TransferHelper.safeTransferFrom(USDC, msg.sender, address(this), amountIn);
        //approve the router to spend the weth
        TransferHelper.safeApprove(USDC, address(swapRouter), amountIn);

        // Naively set amountOutMinimum to 0. In production, use an oracle or other data source to choose a safer value for amountOutMinimum.
        // We also set the sqrtPriceLimitx96 to be 0 to ensure we swap our exact input amount.
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: WMATIC,
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

}