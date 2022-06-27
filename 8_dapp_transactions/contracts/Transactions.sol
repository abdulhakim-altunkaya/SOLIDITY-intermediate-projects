//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Transactions {
    //Address --> Contract
    function deposit() external payable {}

    //Address --> Contract
    function withdraw(address payable _to, uint _amount) external {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "failed to withdraw money");
    }


    //View balance of the contract
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    //View wallet address of the contract
    function getAddress() external view returns(address) {
        return address(this);
    }

}


