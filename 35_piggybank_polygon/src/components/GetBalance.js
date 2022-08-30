import React from 'react';
import { useState } from 'react';
import { ethers } from 'ethers';
import { ABI } from './ContractABI';
import { BigNumber } from 'ethers';


function GetBalance() {
    let [piggyBalance, setPiggyBalance] = useState("");
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
    let data1;
    const getBalance = async () => {
        connectContract();
        const txResponse = await contract.getBalance();
        data1 = ethers.BigNumber.from(txResponse);
        let divisorBig = ethers.BigNumber.from(1000000000000000000); 
        let data2 = data1 / divisorBig;


        const data3 = data2.toString();
        setPiggyBalance(data3);
    }
  return (
    <div>
        <button className='button-56' onClick={getBalance}> How much is inside Piggybank?</button>
        <p>Piggybank balance is: {piggyBalance}</p>
    </div>
  )
}

export default GetBalance;