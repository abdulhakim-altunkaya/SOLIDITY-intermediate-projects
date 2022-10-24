//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    error NotOwner(string message, address caller);
    address payable public owner;
    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwner("you are not owner", msg.sender);
        }
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 public token;
    function setToken(address tokenAddress) external {
        token = IERC20(tokenAddress);
    }

    uint dexARate = 90;
    uint dexBRate = 100;

    mapping(address => uint) public tokenBalances;
    mapping(address => uint) public usdcBalances;

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
        require(allowance >= amount, "allowed/approved amount must be bigger than the flashloan amount");
        usdc.transferFrom(msg.sender, address(this), amount);
    }

    function depositToken(uint amount) external {
        tokenAddress[msg.sender] += amount;
        uint allowance = token.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowed/approved amount must be bigger than the flashloan amount");
        token.transferFrom(msg.sender, address(this), amount);
    }

    function buyToken() external {
        uint tokenToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        token.transfer(msg.sender, tokenToReceive);
    }

    function sellToken() external {
        uint usdcToReceive = ((tokenBalances[msg.sender] * dexBRate) / 100) / (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    function getBalance(address tokenAddress) external view returns(uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function withdraw(address tokenAddress, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }

    receive() external payable {}
}