//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;


library SafeMath { // Only relevant functions
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a); 
        return a — b; 
    } 
    function add(uint256 a, uint256 b) internal pure returns (uint256) { 
        uint256 c = a + b; 
        assert(c >= a);
        return c;
    }
}

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
        balances[msg.sender] -= numTokens;
        balances[receiver] += numTokens;
        emit Transfer(msg.sender, receiver, numTokens);
        return true;   
    }
    //this function is used mostly in a token marketplace scenario.
    //The owner(msg.sender) authorized another account(delegate) to make transfer in his/her name.
    function approve(address delegate, uint numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    //This function let us see how many tokens an owner(owner) has delegated to another account.(delegate)
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    //The delegate account makes token transfer in the name of owner to another account(buyer)
    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    

}