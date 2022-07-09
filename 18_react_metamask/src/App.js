import { useState } from "react";



function App() {
  const { ethereum } = window;


  let [account, setAccount] = useState("");

  const connectMetamask = async () => {
    if (window.ethereum !== "undefined") {
      const accounts = await ethereum.request({method: "eth_requestAccounts"});
      account = accounts[0];
      setAccount(account);
    }
  }
  /*
  const connectContract = async () => {
    const ABI = [
      {
        "inputs": [],
        "name": "myName",
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
            "name": "_name",
            "type": "string"
          }
        ],
        "name": "changeName",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
      }
    ];
    const Address = "0x59885750705f5bd6214792C84dA5cBd5C2BB1CdA";
    window.web3 = await new Web3(window.ethereum);
    window.contract = await new window.web3.eth.Contract(ABI, Address);
    setData(window.contract.defaultBlock);
  }
  */
  const connectContract2 = async () => {
    return;
  }
  return (
    <div className="App">
        <header className="App-header">
          <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
          <p id="areaMetamask">{account}</p>
          <button onClick={connectContract2}>CONNECT TO CONTRACT</button>
          <p id="areaConnection">{data}</p>
        </header>
    </div>
  );
}

export default App;
