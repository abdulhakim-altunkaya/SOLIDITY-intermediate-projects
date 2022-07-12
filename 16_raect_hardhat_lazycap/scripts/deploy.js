
const hre = require("hardhat");

async function main() {
  const Olika = await hre.ethers.getContractFactory("Olika");
  const olika = await Olika.deploy(500);
  await olika.deployed();
  console.log("Olika contract deployed to:", olika.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
