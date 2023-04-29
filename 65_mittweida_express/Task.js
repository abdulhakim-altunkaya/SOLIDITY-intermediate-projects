const Web3 = require('web3');
const contractABI = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "_caller",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_price",
				"type": "uint256"
			}
		],
		"name": "PriceSet",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "uint256",
				"name": "newPrice",
				"type": "uint256"
			}
		],
		"name": "setPrice",
		"outputs": [],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "price",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]; // replace with actual ABI
const contractAddress = '0x748DC478e13F59731236C7592F5345Cb39F12cD7'; // replace with actual contract address
const web3 = new Web3('https://rpc.ankr.com/fantom_testnet'); // replace with your own ANKR endpoint or other Ethereum node URL

const myContract = new web3.eth.Contract(contractABI, contractAddress);

async function setPriceAndListenForEvent(newPrice) {
  const accounts = await web3.eth.getAccounts();
  const sender = accounts[0];
  
  await myContract.methods.setPrice(newPrice).send({ from: sender });
  
  myContract.events.priceSet({ fromBlock: 'latest' }, (error, event) => {
    if (error) console.error(error);
    else console.log(event.returnValues);
  });
}

setPriceAndListenForEvent(100); // replace with desired new price
