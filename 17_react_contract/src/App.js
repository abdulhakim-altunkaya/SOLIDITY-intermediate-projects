import { ethers } from "ethers";
import {useState } from "react";


function App() {
  const {ethereum} = window;

  let [account, setAccount] = useState("");
  let [data, setData] = useState("");
  let [word, setWord] = useState("");

  let erc20;
  const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
    }
  }
  let contract;
  const connectContract = async () => {
    const Address = "0x0988033De05B4D13300fB74Ec2A0F66a5b84978b";
    const ABI = [
      {
        "inputs": [],
        "name": "myWord",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "stateMutability": "view",
        "type": "function",
        "constant": true
      },
      {
        "inputs": [
          {
            "internalType": "string",
            "name": "_word",
            "type": "string"
          }
        ],
        "name": "changeWord",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ];
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    contract = new ethers.Contract(
      Address, ABI, signer
    );
    

  }

  const getData = async () => {
    const more = await contract.myWord();
    setWord(more);
  }
  return (
    <div className="App">
      <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
      <p>{account}</p>
      <button onClick={connectContract}>CONNECT TO CONTRACT</button>
      <p>{data}</p>
      <button onClick={getData}>GET DATA</button>
      <p>{word}</p>
    </div>
  );
}

export default App;
