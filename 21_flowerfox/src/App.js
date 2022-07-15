import { useState } from "react";

function App() {

  const { ethereum } = window;
  let [account, setAccount] = useState("");
  let [contractData, setContractData] = useState("");

  const connectMetamask = async () => {
	return;
  }

  const connectContract = async () => {
    return;
  }
  const getData = async () => {
    return;
  }
  const changeData = async () => {
    return;
  }
  return (
    <div className="App">
        <div id="upperBar">
            <img id="imageIcon" src="flowerfox_5.png" alt="flowerfox token symbol" />
            <div id="titleBar">FLOWERFOX TOKEN</div>
        </div>
        
        <div id="mainArea">
            <div id="readArea">
                
            </div>
            <div id="writeArea">wdwedwedwed</div>
        </div>
    </div>
  );
}
export default App;

