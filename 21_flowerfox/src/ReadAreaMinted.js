import { ethers } from 'ethers'
import React, { useState } from 'react'
import {ABI} from "./ContractABI.js";

function ReadAreaMinted() {
    let [totalMinted, setTotalMinted] = useState("");

    const ABI_CONTRACT = ABI;
    let contract;
    let signer;
    const getTotalSupply = async () => {
      const Address = "0xCF32b1DD878B48d18c287736B7329b13389ed174";
      const ABI = ABI_CONTRACT;
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      signer = provider.getSigner();
      contract = new ethers.Contract(Address, ABI, signer);
      const data = await contract.totalSupply();
      const data2 = data.toString();
      setTotalMinted(data2);
    }

    return (
        <p><button onClick={getTotalSupply}>SEE TOTAL MINTED TOKENS</button> <br />
        The number of total minted tokens until now: {totalMinted} </p>
    )
}

export default ReadAreaMinted