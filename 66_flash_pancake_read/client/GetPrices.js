const ethers = require("ethers");
const { addressFactory, addressRouter, addressFrom, addressTo } = require("./AddressList");

const { erc20ABI, factoryABI, routerABI, pairABI } = require("./AbiList");

//Standard Provider
const provider = new ethers.providers.JsonRpcProvider()