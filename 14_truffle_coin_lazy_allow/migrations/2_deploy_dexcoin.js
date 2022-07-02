const DexCoin = artifacts.require("DexCoin");

module.exports = function (deployer) {
  deployer.deploy(DexCoin);
};
