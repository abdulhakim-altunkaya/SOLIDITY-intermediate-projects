//SPDX-License-Identifier: MIT

pragma solidity >= 0.8.17;

contract Orange {
    uint public price = 100000000000000;  // In Wei = 0.00001 ETH
    string public name;

    event NameSet(address indexed _from, string indexed _name, uint _amount);

    function setName(string memory _name) payable public {
        require(msg.value >= price, "nicht genug Ether");
        name = _name;
        emit NameSet(msg.sender, name, msg.value);
    }
}