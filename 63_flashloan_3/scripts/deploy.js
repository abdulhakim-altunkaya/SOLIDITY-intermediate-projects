// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const Flashy = await hre.ethers.getContractFactory("Flashy");
  const flashy = await Flashy.deploy("0xC809bea009Ca8DAA680f6A1c4Ca020D550210736");

  await flashy.deployed();

  console.log(`Flashy deployed to ${flashy.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
