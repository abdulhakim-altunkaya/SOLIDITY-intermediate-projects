//SPDX-License-Identifier: GPL-3.0

contract PiggyBank {
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "you are not the owner");
    }

    function depositEther() external payable {

    }

    function withdrawEther(address payable _to, uint _amount) external onlyOwner {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "probably no money in contract");
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function getOwner() external view returns(address) {
        return owner;
    }

    function getContractAddress() external view returns(address) {
        return address(this);
    }
}