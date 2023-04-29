//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

contract Task {
    event PriceSet(address _caller, uint _price);

    uint public price;

    function setPrice(uint newPrice) external {
        price = newPrice;
        emit PriceSet(_caller, _price);
    }
}