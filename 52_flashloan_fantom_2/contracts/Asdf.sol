//SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

contract Asdf {
    function getNumber(uint n) public pure returns(uint) {
        return n;
    }

    uint public a;

    function execute2(uint n) external {
        a = this.getNumber(n);
    }

    /*ERROR
    function execute1(uint n) external {
        a = address(this).getx(n);
    }
    */


    Asdf public newcontract;
    function xxx(address otherContract) external {
        newcontract = Asdf(otherContract);
    }
    function yyy(uint n) external {
        a = newcontract.getNumber(n);
    }

    function execute3(uint n) external {
        a = getNumber(n);
    }
}