const RoligCoin = artifacts.require("RoligCoin");

module.exports = function (deployer) {
  deployer.deploy(RoligCoin);
};
