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
