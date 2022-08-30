import React, {useState} from 'react';
import { ethers } from "ethers";
import { ABI } from "./ContractABI.js";

function Withdraw() {
  let[inputValue, setInputValue] = useState("");
  let provider;
  let signer;
  let contract;
  const CONTRACT_ABI = ABI;

  const connectContract = async () => {
    const Address = "0xB5eF00143c460760e02Fd307fba828892A58c88C";
    const ABI = CONTRACT_ABI;

  }

  const withdrawEther = async () => {
    connectContract();
  }
  return (
    <div>
        <br />
        <button className='button-56' id="redButton" onClick={withdrawEther()}>Withdraw Matic (only Owner can click)</button> <br />
        <input value={inputValue} onChange={e => setInputValue(e.target.value)} type="number" placeholder='withdraw...' /> 
        <p>{inputValue}</p>
    </div>
  )
}

export default Withdraw