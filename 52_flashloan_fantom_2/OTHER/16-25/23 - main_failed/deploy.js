const hre = require("hardhat");

async function main() {
  const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
  const flashLoan = await FlashLoan.deploy("0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb");
  await flashLoan.deployed();
  console.log(`flashloan is deployed to ${flashLoan.address}`);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
 