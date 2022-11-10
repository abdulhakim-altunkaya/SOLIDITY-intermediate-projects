//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/*In this file, I am trying to upgrade from version1 to version2. 
It helps but not much. When I upgrade from version1 to version2, uint a resets to zero. 
Because uint a is using its respective contract storage I believe.

Second thing is, I cannot create a different function or variable in Version2 because of interface restrictions.
If create a new variable/function, then I must say "contract Client is Version2" which will be nonsense because it will mean
I cannot upgrade "Client" as I cannot remove "contract Client is Version2" phrase 

I can however, create only a pure function in Version1 and Version2 and I will create "uint a" only in Client so that
 I wont be using storage of Version1 and Version2*/

interface Versions {
    function operation() external;
    function a() external view returns(uint);
}


contract Version1 is Versions {

    uint public a;

    function operation() external {
        a += 8;
    }
}

contract Version2 is Versions {

    uint public a;

    function operation() external {
        a += 1;
    }

}

contract Client {

    Versions public versionContract;

    function setContract(address _contractAddress) external {
        versionContract = Versions(_contractAddress);
    }

    function makeCall() external {
        versionContract.operation();
    }

    function getValue() external view returns(uint) {
        return versionContract.a();
    }
    
}