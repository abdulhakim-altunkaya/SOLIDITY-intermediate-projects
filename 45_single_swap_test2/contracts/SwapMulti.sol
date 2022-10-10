// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.7.6;
pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';

contract SwapMulti {
    ISwapRouter public constant swapRouter = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);

    // This example swaps DAI/WETH9 for single path swaps and DAI/USDC/WETH9 for multi path swaps.

    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant WETH9 = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    

    /*
    swapInputMultiplePools swaps a fixed amount of WETH for a maximum possible amount of DAI through an intermediary pool.
    For this example, we will swap WETH to USDC, then USDC to DAI to achieve our desired output.
    The calling address must approve this contract to spend at least `amountIn` worth of its WETH for this function to succeed.
    amountIn The amount of WETH to be swapped.
    amountOut The amount of DAI received after the swap.
    */
    function swapExactInputMultihop(uint256 amountIn) external returns (uint256 amountOut) {
        // Transfer `amountIn` of WETH to this contract.
        TransferHelper.safeTransferFrom(WETH9, msg.sender, address(this), amountIn);

        // Approve the router to spend WETH.
        TransferHelper.safeApprove(WETH9, address(swapRouter), amountIn);

        /* Multiple pool swaps are encoded through bytes called a `path`. A path is a sequence of token addresses and poolFees that define the pools used in the swaps.
        The format for pool encoding is (tokenIn, fee, tokenOut/tokenIn, fee, tokenOut) where tokenIn/tokenOut parameter is the shared token across the pools.
        Since we are swapping WETH to USDC and then USDC to DAI the path encoding is (WETH9, 0.3%, USDC, 0.3%, DAI). 
        0.3% = uint24(3000) and 0.01% = uint24(100)
        fee information is on info.uniswap pools.*/
        ISwapRouter.ExactInputParams memory params =
            ISwapRouter.ExactInputParams({
                path: abi.encodePacked(WETH9, uint24(3000), USDC, uint24(100), DAI),
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0
            });

        // Executes the swap.
        amountOut = swapRouter.exactInput(params);
    }

    /* swapExactOutputMultihop swaps a minimum possible amount of DAI for a fixed amount of WETH through an intermediary pool.
    For this example, we want to swap DAI for WETH9 through a USDC pool but we specify the desired amountOut of WETH9. Notice how the path encoding is slightly different in for exact output swaps.
    The calling address must approve this contract to spend its DAI for this function to succeed. As the amount of input DAI is variable,
    the calling address will need to approve for a slightly higher amount, anticipating some variance.
    amountOut The desired amount of WETH9.
    The maximum amount of DAI willing to be swapped for the specified amountOut of WETH9.
    amountIn The amountIn of DAI actually spent to receive the desired amountOut.
    */
    function swapExactOutputMultihop(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {
        // Transfer the specified `amountInMaximum` to this contract.
        TransferHelper.safeTransferFrom(DAI, msg.sender, address(this), amountInMaximum);
        // Approve the router to spend  `amountInMaximum`.
        TransferHelper.safeApprove(DAI, address(swapRouter), amountInMaximum);

        /* The parameter path is encoded as (tokenOut, fee, tokenIn/tokenOut, fee, tokenIn)
        The tokenIn/tokenOut field is the shared token between the two pools used in the multiple pool swap. In this case USDC is the "shared" token.
        For an exactOutput swap, the first swap that occurs is the swap which returns the eventual desired token.
        In this case, our desired output token is WETH9 so that swap happpens first, and is encoded in the path accordingly. */
        ISwapRouter.ExactOutputParams memory params =
            ISwapRouter.ExactOutputParams({
                path: abi.encodePacked(WETH9, uint24(3000), USDC, uint24(3000), DAI),
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum
            });

        // Executes the swap, returning the amountIn actually spent.
        amountIn = swapRouter.exactOutput(params);

        // If the swap did not require the full amountInMaximum to achieve the exact amountOut then we refund msg.sender and approve the router to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(DAI, address(swapRouter), 0);
            TransferHelper.safeTransferFrom(DAI, address(this), msg.sender, amountInMaximum - amountIn);
        }
    }
}