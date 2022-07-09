const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();
const privateKeys = [`0x${process.env.PRIVATE_KEY}`];

module.exports = {


  networks: {
    goerli: {
      provider: () => {
        return new HDWalletProvider(privateKeys, `https://polygon-mumbai.g.alchemy.com/v2/0exBPMcf71s82PG_wgz2x8pj7JE3GfCL`);
      },
	    skipDryRun: true,
      network_id: '80001'
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
