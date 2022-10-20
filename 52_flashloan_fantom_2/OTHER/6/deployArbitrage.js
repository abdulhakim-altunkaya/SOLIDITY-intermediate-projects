const hre = require("hardhat");

async function main() {
  const Arbitrage = await hre.ethers.getContractFactory("Arbitrage");
  const arbitrage = await Arbitrage.deploy("0xE339D30cBa24C70dCCb82B234589E3C83249e658");
  await arbitrage.deployed();
  console.log(`flashloan is deployed to ${arbitrage.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
 