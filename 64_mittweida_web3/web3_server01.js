var Web3JS = require("web3");
web3 = new Web3JS('https://rpc.ankr.com/fantom_testnet');

//Checks the version of web3
console.log(web3.version);

//get the version of Geth client I am using
web3.eth.getNodeInfo().then(function(res){
    console.log("Node info: " + res);
})

//Calculate the SHA3 hash (Keccak-256) from “Hello World”.
console.log("SHA3:" + web3.utils.sha3("Hello World"));

//Get the network id of the client
web3.eth.net.getId().then(function(res){
    console.log("Network id: " + res);
})

//Get network name of the client
web3.eth.net.getNetworkType().then(function(res){
    console.log("Network name: "+ res);
})

//Convert 3 Shannon to wei
console.log("3 Shannon  = "+ web3.utils.toWei("3", "Shannon") + " wei");

//Get the current gas price of fantom
web3.eth.getGasPrice().then(function(res){
    console.log("Gas price: " + res);
})

//Get the actual gas limit
web3.eth.getBlock("latest").then(function(res){
    console.log("Gas Limit: "+ res.gasLimit);
})

//Get the hash of Genesis block
web3.eth.getBlock(0).then(function(res){
    console.log("Genesis hash: " + res.hash);
})

//Get the ether balance of this address
web3.eth.getBalance("0x9b2bb6290fb910a960ec344cdf2ae60ba89647f6").then(function(res){
    console.log("Balance: " + res);
})


//Get the sender of a transaction
web3.eth.getTransaction("0x893f954ec8d58853c36bc81ac4ac05e9efa613e55f7789f4cafcad2034b2864f").then(function(res){
    console.log("TX sender: " + res.from);
});