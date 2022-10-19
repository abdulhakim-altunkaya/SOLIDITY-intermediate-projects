//SPDX-License-Identifier: MIT

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

pragma solidity >=0.8.10;

contract Dex {

    address payable public owner;
    modifier onlyOwner(){
        require(msg.sender == owner, "you are not owner");
        _;
    }
    constructor(){
        owner = payable(msg.sender);
    }


    IERC20 private constant dai = IERC20(0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02);
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);

    uint dexARate  = 90;
    uint dexBRate = 100;

    mapping(address => uint) public daiBalances;
    mapping(address => uint) public usdcBalances;

    function depositUSDC(uint amount) external {
        usdcBalances[msg.sender] += amount;
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token balance");
        usdc.transferFrom(msg.sender, address(this), amount);
    }

    function depositDAI(uint amount) external {
        daiBalances[msg.sender] += amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token balance");
        dai.transferFrom(msg.sender, address(this), amount);
    }

    function buyDAI() external {
        uint daiToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        dai.transfer(msg.sender, daiToReceive);
    }

    function sellDAI() external {
        uint usdcToReceive = ((daiBalances[msg.sender] * dexBRate) / 100) / (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    function getBalance(address tokenAddress) external view returns(uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function withdraw(address tokenAddress, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }

    receive() external payable{}

}