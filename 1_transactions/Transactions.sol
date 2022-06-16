//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

interface ITest {
    function withdraw2(address payable _to, uint _amount) external;
}

contract Transactions2 is ITest{
    event Deposit(address sender, uint amount);

    mapping(address => uint) internal stakeAmount;
    address[] internal stakers;

    //WRITE FUNCTIONS
    //Deposit: Address --> Contract
    function deposit() external payable {
        emit Deposit(msg.sender, msg.value);
        stakeAmount[msg.sender] = msg.value;
        stakers.push(msg.sender);
    }


    //Withdrawal1: Address --> Contract
    function withdraw1(address payable _to, uint _amount) external {
        _to.transfer(_amount);
    }

    //Withdrawal2: Contract --> Address
    function withdraw2(address payable _to, uint _amount) external override {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "Either no money or address is wrong");
    }

    function calculateEarning(address _staker) external view returns(uint) {}



    //READ FUNCTIONS
    //Return Contract address
    function getAddress() external view returns(address) {
        return address(this);
    }

    //Return Contract Balance
    function getBalance() external view returns(uint) {
        return address(this).balance;
    }
}