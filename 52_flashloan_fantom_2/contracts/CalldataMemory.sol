//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract DataLocations {
    //STORAGE
    string internal a1 = "apple";
    function get1() external view returns(string memory) {
        return a1;
    }
    //MEMORY -- 23039
    function get2(string memory a2) public pure returns(string memory) {
        return a2;
    }

    //CALLDATA -- 22445
    function get3(string calldata a3) public pure returns(string calldata) {
        return a3;
    }
    function get4(string memory a4) external view returns(string memory) {
        uint storage a10 = a1;
        
    }
/*
****STORAGE****
Storage variables are stored on the blockchain.
Which means you can see a storage variable inside outside functions (NOTE: storage pointers)
They can be updated/modified.
They are expensive.

****MEMORY****
It is data location for function parameters and also function implementation
Which means, you can see a memory variable inside function parameters and also inside function implementation.
Memory variables are mutable/modifiable
Memory variables are also non-persistant. They are deleted when function execution finishes.
Cheaper than Storage.

****CALLDATA****
It is data location for function parameters only
Which means you can see a calldata variable only in function parameters.
calldata variables are immutable/non-modifiable 
calldata variables are non-persistant, they are deleted when function execution finishes.
Cheaper than Memory.

STACK
Function execution space. Variable values are entering in and exiting out. 
Small local variables
FURTHER READING:
Slots
Assignments from one another
Reference type/value type

Data location (memory, storage, and calldata) needs to be specified for reference type variables.
Since uint is a value type, it is not specified.
Stack is also data location for storing small local variables. 
*/
}