import React from 'react';
import { useState } from 'react';

function GetBalance() {
    let [piggyBalance, setPiggyBalance] = useState("");
    const getBalance = async () => {
       return;
    }
  return (
    <div>
        <button className='button-56' onClick={getBalance}> How much is inside Piggybank?</button>
        <p>Piggybank balance is: {piggyBalance}</p>
    </div>
  )
}

export default GetBalance;