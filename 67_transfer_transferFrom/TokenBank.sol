//SPDX-License-Identifier: MIT

pragma solidity >=0.8.7;

/*TokenA contract is an erc20 token contract. */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenBank {

    IERC20 public tokenAContract;

    function setTokenA(address _tokenAddress) external {
        tokenAContract = IERC20(_tokenAddress);
    }
    function getYourBalance() external view returns(uint) {
        return tokenAContract.balanceOf(msg.sender) / (10**18);
    }

    function getContractBalance() external view returns(uint) {
        return tokenAContract.balanceOf(address(this)) / (10**18);
    }

    uint public fee = 3;
    function setFee(uint _fee) external {
        fee = _fee;
    }

    //CONTRACT --> ACCOUNT
    //transfer(recipient, amount)
    function withdraw1() external {
        tokenAContract.transfer(msg.sender, fee*(10**18));
    }

    //ACCOUNT --> CONTRACT
    //approve(spender, amount)
    //transferFrom(sender, recipient, amount)
    //This can only work, if you call "approve" function on tokenContract itself.
    //Later you can come back here to call thiss function.
    function deposit1() external {
        tokenAContract.transferFrom(msg.sender, address(this), fee*(10**18));
    }

    //ACCOUNT --> CONTRACT
    //approve(spender, amount)
    //transferFrom(sender, recipient, amount)
    //ERROR: because it will approve address(this) for address(this). 
    function deposit2() external {
        tokenAContract.approve(address(this), fee*(10**18));
        tokenAContract.transferFrom(msg.sender, address(this), fee*(10**18));
    }

    //ACCOUNT --> CONTRACT
    //ERROR: because it will will send token from Contract to Contract not from Account to Contract.
    function deposit3() external {
        tokenAContract.transfer(address(this), fee*(10**18));
    }

    //_transfer and _approve functions will not work here.
    //Becaue they are not IERC20 methods, they are

}