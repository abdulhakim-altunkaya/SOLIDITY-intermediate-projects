import React from 'react';
import { useState } from 'react';


function ReadArea() {
    const {ethereum} = window;
    let [account, setAccount] = useState("");

    const connectMetamask = async () => {
        if(window.ethereum !== "undefined") {
            const accounts = await ethereum.request({method: "eth_requestAccounts"});
            setAccount(accounts[0]);
        } else {
            setAccount("Please install metamask my good sir")
        }
    }

  return (
    <div className='ReadArea'>
        <h1>Read Area Functions</h1>
        <button onClick={connectMetamask}> Connect to Metamask </button>
        <p>Your Account is: {account}</p>
    </div>
  )
}

export default ReadArea;