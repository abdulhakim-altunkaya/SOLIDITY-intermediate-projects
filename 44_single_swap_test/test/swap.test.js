const { expect } = require("chai");
const { ethers } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";


describe("SwapExamples", function () {
    let accounts;
    let dai;
    let weth;
    let swapExamples;
    before( async () => {
        //get metamask account
        accounts = await ethers.getSigners();
        //initialize the token contracts
        weth = await ethers.getContractAt("IWETH", WETH9);
        dai = await ethers.getContractAt("IERC20", DAI);
        const SwapExamples = await ethers.getContractFactory("SwapExamples");
        swapExamples = await SwapExamples.deploy();
        await swapExamples.deployed();

    })
    /*
    //here are converting 1 eth to dai
    it("SwapExactInputSingle", async function () {

        const amountIn = 10n ** 18n; //this means 1 eth
        await weth.connect(accounts[0]).deposit({value: amountIn});
        await weth.connect(accounts[0]).approve(swapExamples.address, amountIn);

        await swapExamples.swapExactInputSingle(amountIn);
        console.log("DAI Balance", await dai.balanceOf(accounts[0].address));
    });
    */
   //here we want exact daiAmountOut dai. It will convert max eth amount (wethAmountInMax) to exact dai amount (daiAmountOut)
    it("SwapExactOutputSingle", async function () {
        const wethAmountInMax = 10n ** 18n; // this means 1 ether
        const daiAmountOut = 100n * 10n**18n;
        await weth.connect(accounts[0]).deposit({value: wethAmountInMax});
        await weth.connect(accounts[0]).approve(swapExamples.address, wethAmountInMax);

        await swapExamples.swapExactOutputSingle(daiAmountOut, wethAmountInMax);
        console.log("DAI Balance", await dai.balanceOf(accounts[0].address));
    });
});
