// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const Flashloan = await hre.ethers.getContractFactory("Flashloan");
  const flashloan = await Flashloan.deploy("0xE339D30cBa24C70dCCb82B234589E3C83249e658");
  await flashloan.deployed();
  console.log(`flashloan is deployed to ${flashloan.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
