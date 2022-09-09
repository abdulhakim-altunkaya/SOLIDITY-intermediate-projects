//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Crud {
    //CONFLICT OF VALUES: when you deploy contract,constructor values will win.
    //Which means existing values of variables doesnt have effect. 

    string public name = "my counter";
    uint public count = 1;
    constructor() {
        name = "bla bla";
        count = 2;
    }

    string public name2;
    uint public number2;


    function increment(uint _number) external returns(uint) {
        number2 = number2 + _number;
        return number2;
    }

    function getName() external view returns(string memory) {
        return name;
    }

}