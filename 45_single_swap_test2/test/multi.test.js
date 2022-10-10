const { expect } = require("chai");
const { ethers } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const MATIC = "0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0";
const USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7";



describe("swap multi hop exact input", function () {

    let account;
    let dai;
    let weth;
    let usdc;
    let matic;
    let usdt;
    let swapMulti;

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
      const SwapMulti = await ethers.getContractFactory("SwapMulti");
      swapMulti = await SwapMulti.deploy();
      await swapMulti.deployed();
    });

    //swap 1 weth to dai
    it("swap exact 1 weth to usdc and then to dai", async function () {
      const amountIn = 10n ** 18n; //this means 1 eth
      await weth.connect(account).deposit({value: amountIn});
      await weth.connect(account).approve(swapMulti.address, amountIn);
      await swapMulti.swapExactInputMultihop(amountIn);

      console.log("USDC Balance", await usdc.balanceOf(account.address));
      console.log("WETH Balance", await weth.balanceOf(account.address));
      const daiBalance1 = await dai.balanceOf(account.address);
      const daiBalance2 = daiBalance1.toString();
      const daiBalance3 = daiBalance2.slice(0, -18);
      console.log("DAI Balance", daiBalance3);
    });
    
});