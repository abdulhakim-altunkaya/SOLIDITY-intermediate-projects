import React from 'react';
import { useState } from 'react';
import GetBalance from './GetBalance';
import GetContractDetails from './GetContractDetails';


function ReadArea() {
    const {ethereum} = window;
    let [account, setAccount] = useState("");

    const connectMetamask = async () => {
        if(window.ethereum !== "undefined") {
            const accounts = await ethereum.request({method: "eth_requestAccounts"});
            setAccount(accounts[0]);
        } else {
            setAccount("Please install metamask my good sir");
        }
    }

  return (
    <div className='ReadArea'>
        <button className='button-56' onClick={connectMetamask}> Connect to Metamask </button>
        <p>Your Account is: {account}</p>
        <GetBalance/>
        <GetContractDetails/>
    </div>
  )
}

export default ReadArea;