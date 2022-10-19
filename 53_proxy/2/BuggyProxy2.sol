//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/*CounterV1 and V2 should have the same storage layout as BuggyProxy
Thats why there is     
    address public implementation;
    address public admin; 
at the beginning of both contract.*/

contract CounterV1 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count += 1;
    }

    function dec() external {
        count -= 1;
    }
}

contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function upgradeTo(address newImplementation) external {
        require(msg.sender == admin, "you arenot admin");
        implementation = newImplementation;
    }

    function _delegate() private {
        (bool success, bytes memory response ) = implementation.delegatecall(msg.data);
        require(success, "delegateCall has failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }
}

/*
If we want to call a function inside the implementation, than we need to use fallback.

implementation.delegatecall(msg.data) will return 2 result:
    1) a boolean saying if delegateCall is successful or not
    2) bytes of output

Above contract has an error. Because when we want to return some variable values from implementation,
it will not return anything because fallback does not return any data. We need to fix this. 

 */
