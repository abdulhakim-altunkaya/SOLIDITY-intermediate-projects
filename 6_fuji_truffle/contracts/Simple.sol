//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Simple {
    uint public myNum = 5;

    function changeNum(uint _n) external {
        myNum = _n;
    }
}