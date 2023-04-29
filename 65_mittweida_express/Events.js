const Web3 = require('web3');

const url = 'https://rpc.ankr.com/fantom_testnet'  // url string
const web3 = new Web3(new Web3.providers.HttpProvider(url));

contractAddress = "0xEF73C53aad456D8f741cc9beC834a94c4b25dc97";
abi = [
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": true,
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": true,
				"internalType": "string",
				"name": "_name",
				"type": "string"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "NameSet",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "setName",
		"outputs": [],
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"inputs": [],
		"name": "name",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"stateMutability": "view",
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
]

var contract = new web3.eth.Contract(abi,contractAddress);
    console.log("Waiting for event");

    contract.events.NameSet().on('data', function(event){
        console.log(event); 
});
