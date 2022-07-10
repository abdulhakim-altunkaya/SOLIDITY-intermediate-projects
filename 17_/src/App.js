import {useState} from "react";


function App() {
  const {ethereum} = window;

  let [account, setAccount] = useState("");
  let [data, setData] = useState("");

  const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
    }
  }
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
    window.web3 = await new Web3(window.ethereum);
    window.contract = await new window.web3.eth.Contract(ABI, Address);
    setData(window.contract.defaultBlock);

  }

  return (
    <div className="App">
      <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
      <p>{account}</p>
      <button onClick={connectContract}>CONNECT TO CONTRACT</button>
      <p>{data}</p>
    </div>
  );
}

export default App;
