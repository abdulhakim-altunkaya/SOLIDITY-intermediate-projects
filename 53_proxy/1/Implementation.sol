//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract Implementation {

    uint myNumber;

    function setNumber() public {
        myNumber = 0x64;
    }

    function addNumber() public {
        myNumber = myNumber+3;
    }

    function getNumber() public view returns(uint) {
        return myNumber;
    }

}
/* function hashes:
{
    "ba65a523": "addNumber()",
    "f2c9ecd8": "getNumber()",
    "4154b243": "setNumber()"
}
*/