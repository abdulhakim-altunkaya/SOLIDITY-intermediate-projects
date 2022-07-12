import { useState } from "react";

function App() {
  const { ethereum } = window;
  let [account, setAccount] = useState("");
  let [contractData, setContractData] = useState("");
  let [coinBalance, setCoinBalance] = useState("");

  const connectMetamask = async () => {
    if(window.ethereum !== "undefined") {
      const accounts = await ethereum.request({ method: "eth_requestAccounts" });
      setAccount(accounts[0]);
    }
  }

  const connectContract = async () => {
    return;
  }
  const getData = async () => {
    return;
  }

  const getCoins = async () => {
    return;
  }
  return (
    <div className="App">
          <button onClick={connectMetamask}>CONNECT TO METAMASK</button>
          <p>{account}</p>
          <button onClick={connectContract}>CONNECT TO CONTRACT</button> <br /><br />
          <button onClick={getData}>READ FROM CONTRACT</button>
          <p>{contractData}</p>
          <button onClick={getCoins}>GET 10 COINS</button>
          <p>{coinBalance}</p>
    </div>
  );
}
export default App;