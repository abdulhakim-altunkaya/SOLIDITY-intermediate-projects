import React from 'react';
import Deposit from './Deposit';
import Withdraw from './Withdraw';
import Destroy from './Destroy';


function WriteArea() {
  return (
    <div className='WriteArea'>
        <Deposit/>
        <Withdraw/>
        <Destroy/>
    </div>
  )
}

export default WriteArea