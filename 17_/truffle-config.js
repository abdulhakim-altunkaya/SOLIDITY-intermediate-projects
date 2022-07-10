const HDWalletProvider = require("@truffle/hdwallet-provider");
require('dotenv').config();
const privateKeys = [`0x${process.env.PRIVATE_KEY}`];

module.exports = {
  
  networks: {
    matic: {
      provider: () => {
        return new HDWalletProvider(privateKeys, `https://polygon-mumbai.g.alchemy.com/v2/33TtIpx9ZEFVM8oekq6T4GycA9KjC67B`);
      },
	    skipDryRun: true,
      network_id: '80001'
    }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.7"
    }
  },

  
};
