const ethers = require("ethers");
const { addressFactory, addressRouter, addressFrom, addressTo } = require("./AddressList");

const { erc20ABI, factoryABI, routerABI, pairABI } = require("./AbiList");

//Standard Provider
//If it gives json rpc error, change ethers version to 5.7.2
const provider = new ethers.providers.JsonRpcProvider("https://bsc-dataseed.binance.org");
let url = "https://bsc-dataseed1.defibit.io";
let customHttpProvider = new ethers.providers.JsonRpcProvider(url);
//console.log(customHttpProvider);


//Connect Factory Contract
//To read data "provider" is enough. To write data, ie to sign transactions, I need to say "provider.getSigner()"
const contractFactory = new ethers.Contract(addressFactory, factoryABI, provider);
//console.log(contractFactory);

//Connect Router Contract
const contractRouter = new ethers.Contract(addressRouter, routerABI, provider);
console.log(contractRouter);