//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract Proxy {
    uint myNumber2;
    address public implementation;

    function setNumber2() public {
        myNumber2 = 0x28;
    }
    function getNumber2() public view returns(uint) {
        return myNumber2;
    }
    function setImplementation(address _implementation) public {
        implementation = _implementation;
    }
    /*
    implementation.slot is the contract address of the implementation
    */
    fallback() external {
        assembly {

            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall( gas(), sload(implementation.slot), ptr, calldatasize(), 0, 0 )
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        
        }
    }
}

