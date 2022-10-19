const hre = require("hardhat");

async function main() {
  const Flashloan = await hre.ethers.getContractFactory("Flashloan");
  const flashloan = await Flashloan.deploy("0xE339D30cBa24C70dCCb82B234589E3C83249e658");
  await flashloan.deployed();
  console.log(`flashloan is deployed to ${flashloan.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
