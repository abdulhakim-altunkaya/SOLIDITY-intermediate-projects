//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

contract Structs {

    struct Cities {
        string cityName;
        uint cityPopulation; 
    }

    mapping(string => Cities) countyCities;
    
}