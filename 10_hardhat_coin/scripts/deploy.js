const hre = require("hardhat");

async function main() {
  const MyraCoin = await hre.ethers.getContractFactory("MyraCoin");
  const myraCoin = await MyraCoin.deploy();
  await myraCoin.deployed();
  console.log("Token deployed to:", myraCoin.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });