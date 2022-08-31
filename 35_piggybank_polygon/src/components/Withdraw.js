import React, {useEffect, useState} from 'react';
import { ethers } from "ethers";
import { ABI } from "./ContractABI.js";
/* global BigInt */

function Withdraw() {

  const {ethereum} = window;
  let[isOwner, setIsOwner] = useState(false)
  let[account, setAccount] = useState("");
  const connectMetamask = async () => {
    const accounts = await ethereum.request({method: "eth_requestAccounts"});
    setAccount(accounts[0]);
    if (account === "0x1bbeb0f85dc2b84ee8541d85c9d5879d9b499e4a") {
      setIsOwner(true);
    }
  }
  useEffect(() => {
    connectMetamask();
  });


  let[inputValue, setInputValue] = useState("");
  let signer;
  let contract;
  const CONTRACT_ABI = ABI;

  const connectContract = async () => {
    const Address = "0xB5eF00143c460760e02Fd307fba828892A58c88C";
    const ABI = CONTRACT_ABI;
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(Address, ABI, signer);
  }

  const withdrawEther = async () => {
    connectContract();
    let receiver = "0x1bbeb0f85dc2b84ee8541d85c9d5879d9b499e4a";
    let finalAmount = BigInt(inputValue * (10**18));
    const txResponse = await contract.withdrawEther(receiver, finalAmount);
    await txResponse.wait();
  }
  return (
    <div>
        <br />
        {isOwner ?
        <button className='button-56' id="redButton" onClick={withdrawEther}>Withdraw Matic </button> :
        <button className='button-56' id="redButton" onClick={withdrawEther} style={{backgroundColor: "gray"}} disabled>Withdraw Matic (only Owner can click)</button>
        } <br />
        <input value={inputValue} onChange={e => setInputValue(e.target.value)} type="number" placeholder='withdraw...' /> 
    </div>
  )
}

export default Withdraw;


