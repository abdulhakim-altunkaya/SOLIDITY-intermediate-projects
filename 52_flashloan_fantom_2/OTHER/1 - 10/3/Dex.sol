//SPDX-License-Identifier: MIT

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
 
pragma solidity >=0.8.10;

contract Dex {
    address payable public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    address private immutable daiAddress = 0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02;
    address private immutable usdcAddress = 0x06f0790c687A1bED6186ce3624EDD9806edf9F4E;

    IERC20 private dai;
    IERC20 private usdc;

    uint dexARate = 90;
    uint dexBRate = 100;

    mapping(address => uint) public daiBalances;
    mapping(address => uint) public usdcBalances;

    constructor() {
        owner = payable(msg.sender);
        dai = IERC20(daiAddress);
        usdc = IERC20(usdcAddress);
    }

    function depositUSDC(uint _amount) external {
        usdcBalances[msg.sender] += _amount;
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, "check the token balance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    function depositDAI(uint _amount) external {
        daiBalances[msg.sender] += _amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= _amount, "check the token allowance");
        dai.transferFrom(msg.sender, address(this), _amount);
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

    function withdraw(address tokenAddress, uint amount) external onlyOwner{
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }
    receive() external payable{}

}