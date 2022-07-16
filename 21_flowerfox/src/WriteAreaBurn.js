import { ethers } from 'ethers'
import React, { useState } from 'react'
import {ABI} from "./ContractABI.js";

function WriteAreaBurn() {
  let [burnInput, setBurnInput] = useState("");

  const ABI_CONTRACT = ABI;
  let contract;
  let signer;
  const connectContract = async () => {
      const Address = "0xCF32b1DD878B48d18c287736B7329b13389ed174";
      const ABI = ABI_CONTRACT;
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      signer = provider.getSigner();
      contract = new ethers.Contract(Address, ABI, signer);
      console.log(contract.address)
  }
  const removeTokens = async () => {
      connectContract();
      const txResponse = await contract.burnTokens(burnInput)
      const txReceipt = await txResponse.wait();
      console.log(txReceipt);
  }

  return (
    <p>
      <button onClick={removeTokens}>BURN FLOWERFOX TOKENS</button>
      <input value={burnInput} type="number" id="burnAmount" 
      onChange={e => setBurnInput(e.target.value)} />
    </p>
  )

}

export default WriteAreaBurn