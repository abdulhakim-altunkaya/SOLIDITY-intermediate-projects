const hre = require("hardhat");

async function main() {
  const MarketInteractinos = await hre.ethers.getContractFactory("MarketInteractinos");
  const marketInteractinos = await MarketInteractinos.deploy("0xE339D30cBa24C70dCCb82B234589E3C83249e658");
  await marketInteractinos.deployed();
  console.log(`marketInteractinos is deployed to ${marketInteractinos.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
 