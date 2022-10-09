//SPDX-License-Identifier: Unlicense
pragma solidity >=0.7.5;
pragma abicoder v2;

import "./interfaces/ISwapRouter.sol";
import "./libraries/TransferHelper.sol";
//import "@uniswap/swap-router-contracts/contracts/interfaces/IV3SwapRouter.sol";

contract FlashSwapExample {

    address private constant SWAP_ROUTER =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address private constant SWAP_ROUTER_02 =
        0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    address private constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6; //goerli
    address public constant DAI = 0x9D233A907E065855D2A9c7d4B552ea27fB2E5a36; //goerli

    //address private constant WETH = 0xd0A1E359811322d97991E03f863a0C30C2cF029C; //kovan
    // address private constant WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab; // rinkeby
    //address public constant DAI = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa; //kovan
    //address public constant DAI = 0xc7AD46e0b8a400Bb3C915120d284AafbA8fc4735; // rinkeby
    //swaprouter address:   0xE592427A0AEce92De3Edee1F18E0157C05861564
    //Fctory:               0x1F98431c8aD98523631AE4a59f267346ea31F984
    //weth9 - goerli:       0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6
    //weth9-matic:          0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889
    //dai-goerli            0x9D233A907E065855D2A9c7d4B552ea27fB2E5a36

    ISwapRouter public immutable swapRouter = ISwapRouter(SWAP_ROUTER);
    IV3SwapRouter public immutable swapRouter02 = IV3SwapRouter(SWAP_ROUTER_02);

    function safeTransferWithApprove(uint256 amountIn, address routerAddress)
        internal
    {
        TransferHelper.safeTransferFrom(
            DAI,
            msg.sender,
            address(this),
            amountIn
        );

        TransferHelper.safeApprove(DAI, routerAddress, amountIn);
    }

    function swapExactInputSingle(uint256 amountIn)
        external
        returns (uint256 amountOut)
    {
        safeTransferWithApprove(amountIn, address(swapRouter));

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
            .ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH,
                fee: 3000,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactInputSingle02(uint256 amountIn)
        external
        returns (uint256 amountOut)
    {
        safeTransferWithApprove(amountIn, address(swapRouter02));

        IV3SwapRouter.ExactInputSingleParams memory params = IV3SwapRouter
            .ExactInputSingleParams({
                tokenIn: DAI,
                tokenOut: WETH,
                fee: 3000,
                recipient: msg.sender,
                amountIn: amountIn,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            });

        amountOut = swapRouter02.exactInputSingle(params);
    }
}