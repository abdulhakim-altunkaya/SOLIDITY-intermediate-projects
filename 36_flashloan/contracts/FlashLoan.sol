// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Token.sol";

/*We are putting a interface here, because later inside flashloan function
we want to make sure all msg.sender of that function, will have receiveTokens
function inside their contract as shown in the interface. */
interface IReceiver {
    function receiveTokens(address tokenAddress, uint amount) external;
}


//this is flashloan pool contract. In reality, you wont need this, because
//pools and their token address will be readily available by dexes.


/*In the lines below, we are creating a contract variable called "Token"
And saving the address of our token contract inside this variable. Thus
we can "save" our contract inside this variable and use contract functions and
variables. Not sure if I understand it much.

import "./Token.sol";
    Token public token;
    constructor(address _tokenAddress){
        token = Token(_tokenAddress);
    }
 */
contract FlashLoan {

    Token public token;

    //this is to track pool balance. It will later return address(this).balance
    uint public poolBalance;

    constructor(address _tokenAddress){
        token = Token(_tokenAddress);
    }

    /*this is a great function. It shows to to deposit erc20 tokens inside any contract.
    transferFrom is a special function for ERC20 and ERC721 contract.
    To call this function, you will first need to approve this pool contract.
     Function will receive 2 parameters:
        pool adress and amount of tokens. For amount enter 1000000
    
    The approve function must be in Token contract. 
    If inside Token contract and if there is no inheritance, then write it full:
        function approve(address _spender, uint256 _value) public returns(bool success) {
            require(_spender != address(0));
            allowance[msg.sender][_spender] = _value;
            emit Approval(msg.sender, _spender, _value);
            return true;
        }
    If inside Token contract and if there is inheritance, then write it like this:
    function approvePool(address _spender, uint _value) external {
        approve(_spender, uint _value);
    }

    transferFrom resides in Pool contract
    approve resides in Token contract
    
    */
    function depositTokens(uint _amount) external  {
        require(_amount > 0, "you must deposit more than 0");
        token.transferFrom(msg.sender, address(this), _amount);
        //instead of this line below, I can say
        //poolBalance = address(this).balance;
        poolBalance = poolBalance + _amount;
    }

    //When receiver will call this function, this function 
    //should do 3 things: send tokens to receiver, get paid back
    // and ensure loan is paid back
    function flashLoan(uint _borrowAmount) external {
        //here the receiver will call this function. This function in return will
        //call transfer function which is a ERC20 function. 
        //Approved contract (Pool contract) can transfer tokens to another contract.
        token.transfer(msg.sender, _borrowAmount);
        IReceiver(msg.sender).receiveTokens(address(token), _borrowAmount); 
    }
    /*Inside the upper function, first the receiver has called this function,
    then pool contract has called "receiveTokens" function on the contract of 
    receiver.
     */


}