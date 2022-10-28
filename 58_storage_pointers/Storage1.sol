//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

contract Storage2 {

    struct CitiesStruct {
        string cityName;
    }
    
    mapping(uint => CitiesStruct) public cityMapping;
    function addCity(uint index, string memory _cityName) external {
        CitiesStruct memory newCity = CitiesStruct(_cityName);
        cityMapping[index] = newCity;
    }

    function changePop1(uint index) public {
        cityMapping[index].cityName = "aaaa" ;
    }
    function changePop2(uint index) public {
        CitiesStruct storage c = cityMapping[index];
        c.cityName = "aaaa" ;
    }
}

/*
Storage pointers can be used to update a record in mapping or to create a new one.
I was updating the value of a record in mapping. 
    If record contains only 1 bool and nothing else, then updating it was cheaper by using storage.
    If record contains more than 1 value, and if I was using function parameters, then classic was cheaper.
So I am not sure, and it might be: if creating a new record contains multiple parameters, then classic way wins. Otherwise, storage pointer. */