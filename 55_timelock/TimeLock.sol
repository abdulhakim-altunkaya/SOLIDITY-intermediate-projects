//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/*The point of timelock contracts is to increase user trust in the 
contract and owner Even the transactions called by the owner will have 
to wait for some time before being executed.
Delay the transactions so that it will give users some time to react*/
contract TimeLock {
    error NotOwnerError(string message);
    error TimeStampNotInRange(uint currentTime, uint executionTime);

    event Queued(
        bytes32 indexed txId,
        address indexed target,
        uint value, 
        string func, 
        bytes data, 
        uint timestamp
    );
    event Executed(bytes32 indexed txId);
    event Cancelled(bytes32 indexed txId);

    uint public constant MIN_DELAY = 20 seconds;
    uint public MAX_DELAY = 60 seconds;


    address public owner;
    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner(){
        if(msg.sender != owner) {
            revert NotOwnerError("you are not owner");
        }
        _;
    }

    //this is a helper function to queue
    function getTxId(        
        address _target,
        uint _value, 
        string calldata _func, 
        bytes calldata _data, 
        uint _timestamp
    ) internal pure returns(bytes32 txId) {
        //to create a unique tx id, we will use keccak256 and mix everything
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    mapping(bytes32 => bool) internal isQueued;

    function queue(
        address _target, //address of the target contract to call
        uint _value, //amount of ether to send
        string calldata _func, //the function to call
        bytes calldata _data, //data to pass to the function
        uint _timestamp//timestamp after which the function can be executed
    ) external onlyOwner {
        //create a tx record give it a unique id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        //check if tx id is unique
        require(isQueued[txId] == false, "this tx already queued");
        //make sure desired execution time(_timestamp) has a beginning and end date
        if(_timestamp < block.timestamp + MIN_DELAY ||
        _timestamp > block.timestamp + MAX_DELAY) {
            revert TimeStampNotInRange(block.timestamp, _timestamp);
        }
        //queue the tx but
        isQueued[txId] = true;

        emit Queued(txId, _target, _value, _func, _data, _timestamp);
    }
    //this func is payable because there is we might send some ether(uint _value)
    //when we call this function
    function execute(
        address _target,
        uint _value, 
        string calldata _func, 
        bytes calldata _data, 
        uint _timestamp
    ) external payable onlyOwner returns(bytes memory) {
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        require(isQueued[txId] == true, "first put tx on queue");
        require(_timestamp)
        isQueued[txId] = false;
        //lets see if there is a func to call.if there is we will append the data,
        //bytes4: first 4 bytes is our func signature
        bytes memory data;
        if(bytes(_func).length > 0) {
            data = abi.encodePacked( bytes4(keccak256(bytes(_func))), _data );
        } else {
            data = _data;
        }
        //execute tx:
        (bool success, bytes memory res) = _target.call{value: _value}(data);
        require(success, "tx failed");
        emit Executed(txId);
        return res;
    }

    function cancel(bytes32 txId) external onlyOwner {
        require(isQueued[txId] == true, "check your txId, it doesnt exist");
        isQueued[txId] = false;
        emit Cancelled(txId);
    }


    receive() external payable{}
}

contract TestTimeLock {
    address public timeLock;

    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function getTime() external view returns(uint){
        return block.timestamp + 45 seconds;
    }
    function test() external {
        require(msg.sender ==  timeLock);
    }
}