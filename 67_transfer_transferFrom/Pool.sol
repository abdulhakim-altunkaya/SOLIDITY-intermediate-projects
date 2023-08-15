// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/*
    transfer(recipient, amount)
    approve(spender, amount)
    transferFrom(sender, recipient, amount)
    _transfer(sender, recipient, amount)
    _approve(owner, spender, amount)
*/


contract Pool {

    IERC20 public tokenA;

    function setToken(address _tokenAddress) external {
        tokenA = IERC20(_tokenAddress);
    }
    //ACCOUNT --> CONTRACT
    function deposit(uint _amount) external {

    }

    //CONTRACT --> ACCOUNT
    function withdraw(uint _amount) external {

    }

    /*
    ERRORS -- DEPOSIT
    1. "transfer" is a special method defined in IERC20. So, we must use IERC20.

    2. "tokenContract.transfer" transfers tokens from CONTRACT to CONTRACT

    3. "tokenContract._transfer" will not work because "_transfer" is an ERC20 method 
    but it is not defined in IERC20.

    4. "_transfer" is an ERC20 method. And as we are not inheriting from ERC20, we cannot
    use ERC20 methods directly.

    5. "transferFrom" is a special method defined in IERC20. So, we must use IERC20.

    6. "tokenContract.transferFrom" we can use it, it is the correct way, but we cannot use 
    it without "approve". Otherwise everybody would be withdrawing from one another.

    7. "approve
        tokenContract.transferFrom" 
    It will give error because "approve" is a special method defined in IERC20. So, we must use IERC20.
    
    8. "tokenContract.approve
        tokenContract.transferFrom" 
    It will give error because "approve" cannot differentiate between function caller and token sender.
    So it will approve THIS Contract to withdraw tokens of THIS Contract,
    It will not approve THIS Contract to withdraw tokens of OUR METAMASK ACCOUNT.

    9. "tokenContract._approve
        tokenContract.transferFrom" 
    "_approve" is an ERC20 method, it is not IERC20 method. So, we cannot use it here.

    10."_approve
       tokenContract.transferFrom" 
    "_approve" is an ERC20 method. And as we are not inheriting from ERC20, we cannot
    use ERC20 methods directly.

    ERRORS -- WITHDRAW

    1. "tokenContract._transfer" will not work because "_transfer" is an ERC20 method 
    but it is not defined in IERC20.

    2. "_transfer" is an ERC20 method. And as we are not inheriting from ERC20, we cannot
    use ERC20 methods directly.  
   
    10. "approve" on Token Contract

        "tokenContract.transferFrom" Pool Contract

    It will not work because when we "approve" our Metamask account as spender, we also make
    our same Metamask account sender. It means we are sending from our Metamask account to our
    Metamask account.

    11. "_approve" function will not work either because of the same reasons as "_transfer".
    
    */
}
