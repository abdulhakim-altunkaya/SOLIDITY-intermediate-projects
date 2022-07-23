
const hre = require("hardhat");

async function main() {


  const Olika = await hre.ethers.getContractFactory("Olika");
  const olika = await Olika.deploy();

  await olika.deployed();

  console.log("hey man your contract is deployed to:", olika.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
