//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract CounterV1 {
    uint public count;

    function inc() external {
        count +=1;
    }
}

contract CounterV2 {
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
Now we can improve the contract better by removing "implementation" and "admin" variables from CounterV1
and CounterV2 contracts.
We will store these two variables in another slot other than slot 0 and slot 1
To do that we need to know how to write to any storage (I think it means "how to write variables in any slot")
To write to any storage, we will create a library and a test contract for testing.
To store the variables in any slot, we need to wrap them in a struct. We cannot store them directly.
After creating our struct, we will write a function to get the pointer to any slot we want.
Slot itself is in bytes32 data type.
*/ 

library StorageSlot {
    struct AddressSlot {
        address myValue;
    }

    function getAddressSlot(bytes32 _slot) internal pure returns(AddressSlot storage r) {
        assembly {
            r.slot := _slot
        }
    }
}

contract TestSlot {
    bytes32 public constant SLOT = keccak256("TEST_SLOT");

    function getSlot() external view returns(address) {
        return StorageSlot.getAddressSlot(SLOT).myValue
    }

    function writeSlot(address _addr) external {
        StorageSlot.getAddressSlot(SLOT).myValue = _addr;
    }
}