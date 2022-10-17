//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    address payable public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    IERC20 private dai = IERC20(0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02);
    IERC20 private usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 private usdt = IERC20(0x1b901d3C9D4ce153326BEeC60e0D4A2e8a9e3cE3);

    uint dexARate = 90;
    uint dexBRate = 100;

    mapping(address => uint) public daiBalances;
    mapping(address => uint) public usdcBalances;
    mapping(address => uint) public usdtBalances;

    constructor() {
        owner = payable(msg.sender);
    }

    function depositUSDC(uint amount) external {
        usdcBalances[msg.sender] += amount;
        /* The allowance() function returns the token amount remaining, which the spender is currently
         allowed to withdraw from the owner's account. This function returns the remaining balance of 
         tokens from the allowed mapping. The allowed mapping is updated when approve(), transferFrom() */
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token balance");
        usdc.transferFrom(msg.sender, address(this), amount);
    }

    function depositDai(uint amount) external {
        daiBalances[msg.sender] += amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token balance");
        dai.transferFrom(msg.sender, address(this), amount);
    }

    function depositUSDT(uint amount) external {
        usdtBalances[msg.sender] += amount;
        uint allowance = usdt.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token balance");
        usdt.transferFrom(msg.sender, address(this), amount);
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

    function withdraw(address tokenAddress, address receiver, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(receiver, amount);
    }

    receive() external payable {}
}