// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.7;

contract Test {
    string public myName = "liutas";

    function changeName(string memory _name) external {
        myName = _name;
    }
}