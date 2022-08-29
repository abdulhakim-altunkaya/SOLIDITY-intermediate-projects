import React from 'react';
import { useState } from 'react';

function GetContractDetails() {
    let[piggyAddress, setPiggyAddress] = useState("");
    let[piggyOwner, setPiggyOwner] = useState("");
    const getContractDetails = async () => {
      return;
    }
  return (
    <div>
        <button className='button-56' onClick={getContractDetails}> See Contract Details</button>
        <p>Piggybank Contract Address is: {piggyAddress}</p>
        <p>Piggybank Contract's Owner (Abdulhakim Altunkaya) Address is: {piggyOwner}</p>
    </div>
  )
}

export default GetContractDetails