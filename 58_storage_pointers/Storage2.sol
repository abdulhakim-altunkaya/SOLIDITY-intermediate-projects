//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract Numbers {
    uint[] internal myNumbers;

    function setNum1(uint _a, uint _b) external {
        myNumbers = [_a, _b];
        myNumbers.push(8);
    }

    function setNum2(uint _c) external {
        myNumbers[2] = _c;
    }
    
    function setNum3(uint _d) external {
        uint[] storage orange = myNumbers;
        orange[2] = _d;
    }

    function getArray() external view returns(uint[] memory) {
        return myNumbers;
    }
}