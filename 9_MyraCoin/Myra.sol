//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

//The structure is based on ERC20 standard.
contract Myra {

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    //approval will be triggered when an account will be allowed to collect certain amount of tokens.

    string public constant name = "Myra Coin";
    string public constant symbol = "MYRA";
    uint8 public constant decimals = 18;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    constructor(uint256 total) {
        //total is total number of tokens that we want to store in our contract.
        totalSupply_ = total;
        //And here we are storing all tokens to the balance of msg.sender
        balances[msg.sender] = totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns(uint) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint numTokens) public returns(bool) {
        require(numTokens <= balances[msg.sender], "you dont have enough tokens");
        
    }

    function transfer(address receiver, uint numTokens) public returns (bool) {
    require(numTokens <= balances[msg.sender]);
    balances[msg.sender] -= numTokens;
    balances[receiver] += numTokens;
    emit Transfer(msg.sender, receiver, numTokens);
    return true;
}

}