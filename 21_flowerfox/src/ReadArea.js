import React, { useState } from 'react'
import ReadAreaMinted from './ReadAreaMinted';

const ReadArea = () => {
    const { ethereum } = window;
    let [account, setAccount] = useState("");

    const connectMetamask = async () => {
        if(window.ethereum !== "undefined") {
        const accounts = await ethereum.request({method: "eth_requestAccounts"});
        setAccount(accounts[0]);
        } else {
        setAccount("Please install Metamask to your browser");
        }
    }

    return (
        <div id="readArea">
            <p><button onClick={connectMetamask}>CONNECT TO METAMASK</button> <br />
            Your Metamask Account: <br />{account} <br /> </p>
            FlowerFox Token Symbol: FLFX <br />
            FlowerFox Token Cap: 10000 <br />
            FlowerFox Token Standard: ERC20 <br />
            FlowerFox Token Decimals: 18 <br />
            FlowerFox Token Mainnet: Polygon Matic <br />
            FlowerFox Token Contract Account: <br /> 0xCF32b1DD878B48d18c287736B7329b13389ed174 
            <ReadAreaMinted />
        </div>
    )
}

export default ReadArea