require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
module.exports = {
  solidity: "0.8.10",
  networks: {
    polygon: {
      url: process.env.PROVIDER_URL,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  }
};