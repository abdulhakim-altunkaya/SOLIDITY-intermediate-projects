import React, {useState} from 'react';
import {ethers} from "ethers";
import {ABI} from "./ContractABI.js";
import { useEffect } from 'react';


function Destroy() {
  const {ethereum} = window;
  const [isOwner, setIsOwner] = useState(false)
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
  

  let contract;
  let signer;
  const ABI_CONTRACT = ABI;
  const connectContract = async () => {
    const Address = "0xB5eF00143c460760e02Fd307fba828892A58c88C";
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(Address, ABI_CONTRACT, signer);
  }

  const destroyContract = async () => {
    connectContract();
    const txResponse = await contract.destroyContract("0x1bbeb0f85dc2b84ee8541d85c9d5879d9b499e4a");
    await txResponse.wait();
  }

  return (
    <div>
        <br />
        <br />
        <br />
        {isOwner 
        ? <button className='button-56' id='redButton' onClick={destroyContract}>Break Piggybank</button> :
        <button className='button-56' id='redButton' onClick={destroyContract} disabled>Break Piggybank (Only Owner can click)</button>
        }
        
    </div>
  )
}

export default Destroy;