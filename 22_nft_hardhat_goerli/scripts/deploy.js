const hre = require("hardhat");

async function main() {

  const Boredcats = await hre.ethers.getContractFactory("Boredcats");
  const boredcats = await Boredcats.deploy();

  await boredcats.deployed();
  console.log("My good sir, Boredcats deployed to:", boredcats.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
