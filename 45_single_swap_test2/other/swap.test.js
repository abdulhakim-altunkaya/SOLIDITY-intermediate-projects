const { expect } = require("chai");
const { ethers } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const WMATIC = "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889";
// POLYGON: const ETH = "0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619";
// POLYGON: const USDC = "0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174";

describe("swap single input and output", function () {

    let account;
    let dai;
    let weth;
    let usdc;
    let swapExamples;

    before( async () => {
      //get hypotetical account
      let accounts = await ethers.getSigners();
      account = accounts[0];
      //initialize the token contracts
      weth = await ethers.getContractAt("IWETH", WETH9);
      dai = await ethers.getContractAt("IDAI", DAI);
      usdc = await ethers.getContractAt("IUSDC", USDC);
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
    })
    
/*
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
  
    */
/*
    //Swap 1 wmatic to usdc
    it("convert 1 ETH to usdc", async () => {
      //get hypotetical account
      let accounts = await ethers.getSigners();
      account = accounts[0];
      //initialize the token contracts
      usdc = await ethers.getContractAt("IUSDC", USDC);
      eth = await ethers.getContractAt("IETH", ETH);
      const SwapExamples = await ethers.getContractFactory("SwapExamples");
      swapExamples = await SwapExamples.deploy();
      await swapExamples.deployed();

      const amountIn = 100n * 10n**18n;
      await eth.connect(account).deposit({value: amountIn});
      await eth.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.exactInputWMATIC(amountIn);
      console.log("USDC BALANCE", await usdc.balanceOf(account.address));
    })
    //here we are converting 100 wmatic to dai
    it("swap exact 100 wmatic to dai", async function () {
      const amountIn = 100n * 10n ** 18n; //this means 1 eth
      await wmatic.connect(account).deposit({value: amountIn});
      await wmatic.connect(account).approve(swapExamples.address, amountIn);
      await swapExamples.swapExactInputSingle(amountIn);
      console.log("DAI Balance", await dai.balanceOf(account.address));
    });
    */
});