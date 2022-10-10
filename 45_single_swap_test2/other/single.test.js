const { expect } = require("chai");
const { ethers } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const MATIC = "0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0";
const USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7";



describe("swap single input and output", function () {

    let account;
    let dai;
    let weth;
    let usdc;
    let matic;
    let usdt;
    let swapExamples;

    before( async () => {
      //get hypotetical account
      let accounts = await ethers.getSigners();
      account = accounts[0];
      //initialize the token contracts
      weth = await ethers.getContractAt("IWETH", WETH9);
      dai = await ethers.getContractAt("IDAI", DAI);
      usdc = await ethers.getContractAt("IUSDC", USDC);
      matic = await ethers.getContractAt("IMATIC", MATIC);
      usdt = await ethers.getContractAt("IUSDT", USDT);
      const SwapExamples = await ethers.getContractFactory("SwapExamples");
      swapExamples = await SwapExamples.deploy();
      await swapExamples.deployed();
    });

    //swap 1 weth to dai
    it("swap exact 1 weth to dai", async function () {
      const amountIn = 10n ** 18n; //this means 1 eth
      await weth.connect(account).deposit({value: amountIn});
      await weth.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.swapExactInputSingle(amountIn);
      console.log("DAI Balance", await dai.balanceOf(account.address));
    });
    //Swap 1 weth to usdc
    it("swap exact 1 eth to usdc", async () => {
      const amountIn = 10n ** 18n;
      await weth.connect(account).deposit({ value: amountIn });
      await weth.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.exactInputUSDC(amountIn);
      console.log("USDC Balance", await usdc.balanceOf(account.address));
    });
    //Swap 100 Matic to USDT
    it("swap exact 100 Matic to usdT", async () => {
      const amountIn = 100n * 10n ** 18n;
      await matic.connect(account).deposit({ value: amountIn });
      await matic.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.exactInputUSDT(amountIn);
      console.log("USDT Balance", await usdt.balanceOf(account.address));
      console.log("USDT Balance", await matic.balanceOf(account.address));
    })
    //swap 10 weth to matic
    it("swap exact 100 weth to matic", async function () {
      const amountIn = 100n * 10n ** 18n; //this means 10 eth
      await weth.connect(account).deposit({value: amountIn});
      await weth.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.exactInputMATIC(amountIn);
      const maticBalance = await matic.balanceOf(account.address);
      const maticBalance2 = await maticBalance.toString();
      const maticBalance3 = await maticBalance2.slice(0, -18);
      console.log("MATIC Balance", maticBalance3);
    });
    //here we want exact daiAmountOut dai (100). It will convert max eth amount (wethAmountInMax) to exact dai amount (daiAmountOut)
    it("Swap max 1 weth to exact 100 dai", async () => {
      const wethAmountInMax = 10n**18n;//this means 1 weth
      const daiAmountOut = 100n*10n**18n; // this means 100 dai
      await weth.connect(account).deposit({ value: wethAmountInMax });
      await weth.connect(account).approve(swapExamples.address, wethAmountInMax);
      await swapExamples.swapExactOutputSingle(daiAmountOut, wethAmountInMax);

      const daiBalance = await dai.balanceOf(account.address);
      const daiBalance2 = await daiBalance.toString();
      const daiBalance3 = await daiBalance2.slice(0, -18);
      console.log("DAI Balance: ", daiBalance3);

      const wethBalance = await weth.balanceOf(account.address);
      const wethBalance2 = await wethBalance.toString();
      const wethBalance3 = await wethBalance2.slice(0, -18);
      console.log("WETH Balance (after removing 18 zeros)", wethBalance3);
      console.log("WETH Balance: ", wethBalance);
    });
  /*
    //It will convert max usdt amount (wethAmountInMax) to exact matic amount (daiAmountOut)
    it("Swap max 1000 usdt weth to exact 100 Matic", async () => {
      const usdtAmountInMax = 1000n * 10n**18n;//this means 1000 usdt
      const maticAmountOut = 100n*10n**18n; // this means 100 matic
      await usdt.connect(account).deposit({ value: usdtAmountInMax });
      await usdt.connect(account).approve(swapExamples.address, usdtAmountInMax);
      await swapExamples.exactOutputMatic(maticAmountOut, usdtAmountInMax);
      const maticBalance = await matic.balanceOf(account.address);
      console.log("MATIC Balance: ", maticBalance);
    });

*/
    
});