const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();
const privateKeys = [`0x${process.env.PRIVATE_KEY}`];

module.exports = {


  networks: {
    goerli: {
      provider: () => {
        return new HDWalletProvider(privateKeys, `https://eth-goerli.g.alchemy.com/v2/SGj08NvjAXmtt8VM8guMQkO2g4VdmR1W`);
      },
	    skipDryRun: true,
      network_id: '5'
    }
  },


  mocha: {

  },


  compilers: {
    solc: {
      version: "0.8.7",      

    }
  },

  
};
