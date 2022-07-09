import { useRef, useState } from "react";
import { useWeb3React } from "@web3-react/core"
import { injected } from "./wallet/Connectors"

function App() {
  const { active, account, library, connector, activate, deactivate } = useWeb3React();

  const connectMetamask = async () => {
    try {
      await activate(injected)
    } catch (ex) {
      console.log(ex)
    }
  }
  const connectContract = async () => {
    return;
  }
  return (
    <div className="App">
      <header className="App-header">
        <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
        <p id="areaMetamask">{account}</p>
        <button onClick={connectContract}>CONNECT TO CONTRACT</button>
        <p id="areaConnection"></p>
      </header>
    </div>
  );
}

export default App;
/*
let account;
const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
        const accounts = await ethereum.request({method: "eth_requestAccounts"});
        account = accounts[0];
        document.getElementById("userArea").innerHTML = `user account is: ${account}`;
    }
}

const connectContract = async () => {
    const Address = "0xAD4668343BABFA92799022aB6A3Dd07cE7BCB132";
    const ABI = 
    window.web3 = await new Web3(window.ethereum);
    window.contract = await new window.web3.eth.Contract(ABI, Address);
    document.getElementById("contractArea").innerHTML = window.contract.defaultBlock;
}


export function MyComponent() {
  const isAvailable = useRef(false);
  useEffect(() => {
    isAvailable.current = typeof window !== "undefined" && window.location.search;
  }, []);
  return <div>Display the qs: {isAvailable.current || 'nothing'}</div>;
}


*/