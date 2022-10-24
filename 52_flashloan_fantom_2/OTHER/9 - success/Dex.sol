//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    
    address payable public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }
    constructor() {
        owner = payable(msg.sender);
    }

    IERC20 private constant dai = IERC20(0xAC1a9503D1438B56BAa99939D44555FC2dC286Fc);
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 private constant usdt = IERC20(0x1b901d3C9D4ce153326BEeC60e0D4A2e8a9e3cE3);

    uint dexARate = 90;
    uint dexBRate = 100;

    mapping(address => uint) internal daiBalances;
    mapping(address => uint) internal usdcBalances;
    mapping(address => uint) internal usdtBalances;

    /*deposit functions below assumes you have already approved this contract. Logic:
    1) approve dex contract to spend a certain amount on your behalf.
    This approval is done on remix by using buttons provided by ERC20
    2) Then you can check allowance buttons to see what amount you have approved. I mean the approve() limit.
    Functions below are making sure, the allowance/approve amount is bigger than the flashloan amount.
    NOTE: The deposit functions below are not the same with sending usdc/dai to this contract by using metamask.
    Because by sending dai/usdc to contract by using metamask, we are providing some liquidity.
    Whereas the functions below are for flashloan operations. */

    /* 
    transferFrom: for coins that we do not own. Thats why it is used with approve( and additionally allowance)
    transfer:    for coins that we own. 
    allowance(sender, spender)
    transferFrom(sender, recipient, amount)  
    */
    function depositUSDC(uint amount) external {
        usdcBalances[msg.sender] += amount;
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowed/approved amount must be bigger than flashloan amount");
        usdc.transferFrom(msg.sender, address(this), amount);
    }

    function depositDAI(uint amount) external {
        daiBalances[msg.sender] += amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowed/approved amount must be bigger than flashloan amount");
        dai.transferFrom(msg.sender, address(this), amount);
    }

    function depositUSDT(uint amount) external {
        usdtBalances[msg.sender] += amount;
        uint allowance = usdt.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowed/approved amount must be bigger than flashloan amount");
        usdt.transferFrom(msg.sender, address(this), amount);
    }

    function buyUSDT() external {
        uint usdtToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        usdt.transfer(msg.sender, usdtToReceive);
    }
    function sellUSDT() external {
        uint usdcToReceive = ((usdtBalances[msg.sender] * dexBRate) / 100) / (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
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

    function withdraw(address tokenAddress, uint amount) external {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }
    receive() external payable{}
}
