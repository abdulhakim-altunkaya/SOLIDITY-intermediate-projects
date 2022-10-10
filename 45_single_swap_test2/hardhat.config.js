require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.7.6",
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.g.alchemy.com/v2/4X4MaNu5qcNpwsNw-ryjGgRmrCuH0tpL"
      },
    },
  },
};
/*
module.exports = {
  solidity: "0.7.6",
  networks: {
    hardhat: {
      forking: {
        url: "https://polygon-mainnet.g.alchemy.com/v2/P6SwIoJFJNfdCabKfWCy6tFYYoLQ4ZMc"
      },
    },
  },
};
 */