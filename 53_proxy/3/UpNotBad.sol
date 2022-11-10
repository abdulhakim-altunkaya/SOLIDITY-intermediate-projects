//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/*In this file, I will using only the storage of Client contract. Version1 and Version2 will only have
implementation*/

interface Versions {
    function operation(uint a) external pure returns(uint);
}


contract Version1 is Versions {

    function operation(uint a) external pure returns(uint) {
        return a + 8;
    }
}

contract Version2 is Versions {

    function operation(uint a) external pure returns(uint) {
        return a + 1;
    }

}

contract Client {
    uint public number;

    Versions public versionContract;

    function setContract(address _contractAddress) external {
        versionContract = Versions(_contractAddress);
    }

    function makeCall(uint a) external {
        uint value = versionContract.operation(a);
        number += value;
    }
    
}