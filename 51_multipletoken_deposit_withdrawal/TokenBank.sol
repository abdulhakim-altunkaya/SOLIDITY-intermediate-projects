// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./helpers/IERC20.sol";

contract TokenBank {

    function getBalance(address _tokenAddress) external view returns(uint) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    //this function below is meaningless, because it is returning the balance of ether
    //not the balance from of coins.
    function balance() external view returns(uint) {
        return address(this).balance;
    }

    function withdraw1(address _tokenAddress, address receiver) external {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(receiver, token.balanceOf(address(this)));
    }
    function withdraw2(address _tokenAddress, address receiver, uint amount) external {
        IERC20 token = IERC20(_tokenAddress);
        uint amount2 = amount * (10**18);
        token.transfer(receiver, amount2);
    }
    
    /*
    //you cannot use call here because call is for ether transfer. not for token transfer.
    //so this function below will of course not work.
    function withdraw2(address to, address _tokenAddress) external {
        IERC20 token = IERC20(_tokenAddress);
        (bool success, ) = to.call{value: token.balanceOf(address(this)) }("");
        require(success, "call method failed");
    }
    */



}
