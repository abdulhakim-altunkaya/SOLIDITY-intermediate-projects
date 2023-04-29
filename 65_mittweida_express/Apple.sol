//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

contract Apple {
    struct Profile {
        string name;
        uint balance;
    }

    mapping(address => Profile) public profilesMapping;

    function payIn(string memory _name) public payable {
        profilesMapping[msg.sender].name = _name;
        profilesMapping[msg.sender].balance = profilesMapping[msg.sender].balance + msg.value;
    }

    function getMyDetails() public view returns(string memory, uint) {
        return (profilesMapping[msg.sender].name, profilesMapping[msg.sender].balance);
    }
}