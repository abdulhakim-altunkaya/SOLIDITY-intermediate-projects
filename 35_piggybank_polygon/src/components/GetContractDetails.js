import React from 'react';
import { ethers } from 'ethers';
import { useState } from 'react';
import {ABI} from "./ContractABI.js";

function GetContractDetails() {
    let[piggyAddress, setPiggyAddress] = useState("");
    let[piggyOwner, setPiggyOwner] = useState("");
    let contract;
    let signer;
    const ABI_CONTRACT = ABI;

    const connectContract = async () => {
        const Address = "0xB5eF00143c460760e02Fd307fba828892A58c88C";
        const ABI = ABI_CONTRACT;
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        signer = provider.getSigner();
        contract = new ethers.Contract(Address, ABI, signer);
        console.log(contract.address);
    }

    const getDetails = async () => {
        connectContract();
        const txResponse1 = await contract.getContractAddress();
        const txResponse2 = await contract.getOwner();
        const data1 = txResponse1.toString();
        const data2 = txResponse2.toString();
        setPiggyAddress(data1);
        setPiggyOwner(data2);
    }

    return (
        <div>
            <button className='button-56' onClick={getDetails}> See Contract Details</button>
            <p>Piggybank Contract Address is: {piggyAddress}</p>
            <p>Piggybank Contract's Owner (Abdulhakim Altunkaya) Address is: {piggyOwner}</p>
        </div>
    )
}

export default GetContractDetails;
