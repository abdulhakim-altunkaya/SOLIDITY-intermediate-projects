//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract CounterV1 {
    uint public count;

    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
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

Buggyproxy is buggy because  when we use delegatecall,
we execute the function of V1 and we use storage of Buggyproxy. 
On storage of V1, at slot 0, there is uint count. 
On storage of Buggyproxy, at slot 0, there is implementation address.
So, instead of increasing uint count, we are adding 1 to implementation address, which is weird.
To fix this problem, we need to make sure all implementation contracts will have the same storage layout as proxy.
Check BuggyProxy2 for correct version. 

PRACTICE:
Deploy all 3 contracts on Remix
Copy the address of Proxy and go deployment section, open V1
Paste address of Proxy to the "at the" input area. And deploy it.
This is weird, we will use interface of V1 but on the background it will be Proxy.
It is weird because we will use address and storage of Proxy, but we will use interface of v1.

 */
