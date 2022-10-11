require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-truffle4");
require("dotenv").config();

module.exports = {
  solidity: "0.8.0",
  networks: {
    localganache: {
      url: process.env.PROVIDER_URL,
      accounts: [`0x${process.env.PRIVATE_KEY}`]
    }
  }
};