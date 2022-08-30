import React from 'react';
import {ABI} from "./ContractABI.js";
import { ethers } from "ethers";
import { useState } from 'react';

function Deposit() {
  let[inputValue, setInputValue] = useState("");
  let signer;
  let contract;
  const ABI_CONTRACT = ABI;

  const connectContract = async () => {
    const Address = "0xB5eF00143c460760e02Fd307fba828892A58c88C";
    const ABI = ABI_CONTRACT;
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(Address, ABI, signer);
  }
  const depositMatic = async () => {
    connectContract();
    const txResponse = await contract.depositEther({value: inputValue});
    await txResponse.wait();
  }
  return (
    <div>
      <button className='button-56' onClick={depositMatic}>Deposit Matic in Piggybank</button> <br />
      <input value={inputValue} type="number" placeholder='deposit...' onChange={e => setInputValue(e.target.value)} /> 
    </div>
  )
}

export default Deposit;