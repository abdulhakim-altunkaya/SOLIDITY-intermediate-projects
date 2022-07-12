import { ethers } from "ethers";
import { useState } from "react";

function App() {
  const { ethereum } = window;
  let [account, setAccount] = useState("");
  let [contractData, setContractData] = useState("");

  const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
    }
  }

  let contract;
  let signer;
  const connectContract = async () => {
    const ABI = [
      {
        "inputs": [],
        "name": "changeFlower",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      },
      {
        "inputs": [],
        "name": "myFlower",
        "outputs": [
          {
            "internalType": "string",
            "name": "",
            "type": "string"
          }
        ],
        "stateMutability": "view",
        "type": "function"
      }
    ]
    const Address = "0x40497eB487B766c7d20ec0Fc8d91998120FB998F";
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(Address, ABI, signer);
    console.log(contract.address);
  }
  const getData = async () => {
    const data = await contract.myFlower();
    setContractData(data);
  }

  const changeData = async () => {
    return;
  }
  return (
    <div>
          <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
          <p>{account}</p>
          <button onClick={connectContract}>CONNECT TO CONTRACT</button> <br /><br />
          <button onClick={getData}>READ FROM CONTRACT</button>
          <p>{contractData}</p>
          <button onClick={changeData}>CHANGE DATA</button>
    </div>
  );
}
export default App;