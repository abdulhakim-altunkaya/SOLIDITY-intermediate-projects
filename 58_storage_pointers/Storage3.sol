//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract Storage2 {

    struct Camper {
        bool isHappy;
    }
    
    mapping(uint => Camper) public campers;
    
    function setStatus1(uint index) public {
        campers[index].isHappy = true;
    }
    function setStatus2(uint index) public {
        Camper storage c = campers[index];
        c.isHappy = false;
    }
}