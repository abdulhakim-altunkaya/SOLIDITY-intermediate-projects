import { ethers } from 'ethers'
import React, { useState } from 'react'
import {ABI} from "./ContractABI.js";

const WriteAreaMint = () => {

  let [mintInput, setMintInput] = useState("");

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
  const getTokens = async () => {
      connectContract();
      const txResponse = await contract.mintTokens(mintInput)
      const txReceipt = await txResponse.wait();
      console.log(txReceipt);
  }
  return (
    <p>
      <button onClick={getTokens}>MINT FLOWERFOX TOKENS</button>
      <input value={mintInput} type="number" id="mintAmount" 
      onChange={e => setMintInput(e.target.value)} /> <br />
      1) On the left, click on "Connect to Metamask" <br />
      2) Copy FlowerFox Token Contract Address <br />
      3) Open Metamask, make sure you are on "Matic Mainnet", <br />
      4) On Metamask, click on "import tokens" <br />
      5) Paste FlowerFox Token Contract Address in "Token Contract Address" <br />
      6) Wait 5 seconds and then click on "Add Custom Token". <br />
      7) You can mint between 1 to 10 tokens.
    </p>
  )
}

export default WriteAreaMint