const hre = require("hardhat");

async function main() {

  const FlashLoan = await hre.ethers.getContractFactory("FlashLoan");
  const flashLoan = await FlashLoan.deploy("0xC809bea009Ca8DAA680f6A1c4Ca020D550210736");

  await flashLoan.deployed();

  console.log(`flashLoan deployed to ${flashLoan.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});