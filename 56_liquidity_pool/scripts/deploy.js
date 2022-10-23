const hre = require("hardhat");

async function main() {
  const Market = await hre.ethers.getContractFactory("Market");
  const market = await Market.deploy("0xE339D30cBa24C70dCCb82B234589E3C83249e658");
  await market.deployed();
  console.log(`market is deployed to ${market.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
 