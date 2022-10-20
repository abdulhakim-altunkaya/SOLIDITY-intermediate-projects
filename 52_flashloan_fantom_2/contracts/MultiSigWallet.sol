//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount); // when ether is deposited
    event Submit(uint indexed txId); // when a transaction is submitted
    event Approve(address indexed owner, uint indexed txId); // when they approved a tx
    event Revoke(address indexed owner, uint indexed txId); // when they change their mind want to revoke latest tx
    event Execute(uint indexed txId); // once there is sufficient number of approvals, then tx can be executed.

    //create a list of owners:
    address[] public owners;
    mapping(address => bool) public isOwner;
    modifier onlyOwner() {
        require(isOwner[msg.sender] == true, "you are not owner");
        _;
    }

    //we can set the number of approvals required for each tx to execute

    uint public required;

    //lets create a struct that will store the txs
    struct Transaction {
        address to;
        uint value; //amount of eth sent to the "to" address
        bytes data; //data to be sent to the "to" address
        bool executed; //once the tx is executed, we will set this to "true"
    }

    //list of txs
    Transaction[] public transactions;

    //uint is tx index number, address is one of owners, bool is his voting color
    //it will store the approvals of owners
    mapping(uint => mapping(address => bool)) public approved;

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "enter some owners");
        require( _required > 0 &&  _required <= _owners.length, "invalid required Owners number");
        for(uint i=0; i<_owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "owner cannot be address(0)");
            require(isOwner[owner] == false, "somebody is already member");
            isOwner[owner] = true;
            owners.push(owner);
        }
        required = _required;
    }

    receive() external payable{
        emit Deposit(msg.sender, msg.value);
    }

    modifier txExists(uint _txId) {
        require(_txId >= 0, "tx id cannot be minus");
        require(_txId < transactions.length, "tx id does not exist");
        _;
    }
    modifier notApproved(uint _txId) {
        require(approved[_txId][msg.sender] == false, "tx already approved");
        _;
    }

    modifier notExecuted(uint _txId) {
        require(transactions[_txId].executed == false, "tx already executed");
        _;
    }

    //Since this function is external, using "calldata" for _data is cheaper 
    //on gas instead of "memory"
    function submit(address _to, uint _value, bytes calldata _data) external onlyOwner{
        Transaction newTx = Transaction(_to, _value, _data, false);
        transactions.push(newTx);
        //transactions.length is already 1 because we already pushed above proposal
        emit Submit(transactions.length - 1);
    }

    function approve(uint _txId) 
    external onlyOwner txExists(_txId) notApproved(_txId) notExecuted(_txId) {
        approved[_txId][msg.sender] == true;
        emit Approve(msg.sender, _txId);
    }

    function _getApprovalCount(uint _txId) private view returns(uint) {
        uint approvalNumber;
        for(uint i=0; i<owners.length; i++) {
            if(approved[_txId][owners[i]] == true){
                approvalNumber += 1;
            }
        }
        return approvalNumber;     
    }
    /* SAME FUNCTION AS ABOVE AND EVEN CHEAPER:
    function _getApprovalCount(uint _txId) private view returns(uint approvalNumber) {
        for(uint i=0; i<owners.length; i++) {
            if(approved[_txId][owners[i]] == true){
                approvalNumber += 1;
            }
        }  
    }
     */
    function executeTx(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        uint approvalNum = _getApprovalCount(_txId);
        require(approvalNum >= required, "approvals less than required");
        transactions[_txId].executed = true;
        uint xValue = transactions[_txId].value;
        bytes xData = transactions[_txId].data;
        address xTo = transactions[_txId].to;
        (bool success, ) = xTo.call{value: xValue}(xData);
        require(success, "ether transfer failed. Lo: executeTx");
        emit Execute(_txId);
    }
    /*SAME AS ABOVE:
    function executeTx(uint _txId) external onlyOwner txExists(_txId) notExecuted(_txId) {
        require(_getApprovalCount(_txId) >= required, "approvals less than required");
        Transaction storage transaction = transactions[_txId];
        transaction.executed = true;
        (bool success, ) = transaction.to.call{value: transaction.value}(transction.data);
        require(success, "ether transfer failed. Lo: executeTx");
        emit Execute(_txId);
    }
    
     */

    function revokeApproval(uint _txId) onlyOwner txExists(_txId) notExecuted(_txId) {
        require(approved[_txId][msg.sender] == true, "tx already not approved");
        approved[_txId][msg.sender] = false;
        emit Revoke(msg.sender, _txId);
    }


}

