const hre = require("hardhat");

async function main() {
  const Dex = await hre.ethers.getContractFactory("Dex");
  const dex = await Dex.deploy();
  await dex.deployed();
  console.log(`Dex is deployed to ${dex.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
