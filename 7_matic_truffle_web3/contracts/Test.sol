//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.13;

contract Test {
	uint public myNumber = 5;

	function changeNumber(uint _newNumber) external {
		myNumber = _newNumber;
	}
}