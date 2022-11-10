//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract CounterV1 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count +=1;
    }
}

contract CounterV2 {
    address public implementation;
    address public admin;
    uint public count;

    function inc() external {
        count +=1;
    }

    function dec() external {
        count -=1;
    }

}

contract BuggyProxy {
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    //here we are forwarding calls to implementation contract ???
    function _delegate(address _implementation) private {
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())
            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
    fallback() external payable {
        _delegate(implementation);
    }
    receive() external payable {
        _delegate(implementation);
    }



    function upgradeTo(address _implementation) external {
        require(msg.sender == admin, "you are not admin");
        implementation = _implementation;
    }
}
/*
Actually now I understand it better. Logic of Proxy is not what you think.
You are creating a contract to use as a storage.
Then you are creating implementation contracts to use that storage contract. 
Our storage contract is BuggyProxy.
Our implementation contracts are CounterV1 and CounterV2
As we are using only storage of the BuggyProxy, we dont need to define any specific variable in it.
In fact,that BuggyProxy can be used for all your future contracts. It acts like a depot area. 

You need deploy CounterV1, CounterV2,..and Proxy.
Then you need to copy their addresses and make them implementation contract inside Proxy by using upgradeTo function.
Then you need to deploy them again "at the address" of the Proxy.
 at the address of the 
*/ 