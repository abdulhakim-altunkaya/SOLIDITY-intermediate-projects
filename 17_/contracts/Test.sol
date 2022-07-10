//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

contract Test {
    string public myWord = "Flower";
    
    function changeWord(string memory _word) external {
        myWord = _word;
    }
}