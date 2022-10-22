//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract TimeLock {
    error NotOwnerError();
    address public owner;
    constructor() {
        owner = msg.sender
    }
    modifier onlyOwner(){
        if(msg.sender != owner) {
            revert NotOwnerError();
        }
        _;
    }
    function getTxId(
        address _target, 
        uint _value, 
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns(bytes32 txId) {
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }
    //we will check if tx is queued or not
    mapping(bytes32 => bool)
    function queue(
        address _target, 
        uint _value, 
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
    }


    function execute() external onlyOwner {

    }
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function test() external {
        require(msg.sender ==  timeLock);
    }
}