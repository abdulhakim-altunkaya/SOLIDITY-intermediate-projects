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

    /* The thing is if I click on connectContract, then getData the state will change. Then if I click on changeData, it will give error
    However, if I click on connectContract, then changeData and then getData, there wont be errors. 

    The reason is, when the state of the component changes, it resets everything. That is why I cannot changeData later because 
    "contract" object will be reset.

    To fix it, 3 solutions: 
    1) use html and vanilla javascript instead of react
    2) Or click on this order: connectContract, changeData, getData
    3) Or wrap connectContract inside useEffect() and save variable values inside useRef. Which means a react shithole.
     */
  const changeData = async () => {
    const txResponse = await contract.changeFlower();
    const txReceipt = await txResponse.wait();
    console.log(txReceipt);
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