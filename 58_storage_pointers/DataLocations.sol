//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract DataLocations {
    //STORAGE
    string internal word = "apple";
    function get1() external view returns(string memory) {
        string storage asdf = word;
    }


    //MEMORY

    //CALLDATA

    //STACK

    //MIX

/*
****STORAGE****
Storage variables are stored on the blockchain.
All variables that are outside functions are storage variables. Inside functions there can be storage pointers.
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

****STACK****
Stack is also data location for storing small local and value type variables. 
Function execution space. Variable values are entering in and exiting out. 


FURTHER READING:
Slots
Assignments from one another
Reference type/value type

NOTE: Data location (memory, storage, and calldata) needs to be specified for reference type variables.
Since uint is a value type, it is not specified.

*/
}