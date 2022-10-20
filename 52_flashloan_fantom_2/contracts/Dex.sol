//SPDX-License-Identifier: MIT

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

pragma solidity >=0.8.10;

contract Dex {
    address payable public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }
    constructor() {
        owner = payable(msg.sender);
    }

    IERC20 private constant dai = IERC20(0xc469ff24046779DE9B61Be7b5DF91dbFfdF1AE02);
    IERC20 private constant usdc = IERC20(0x06f0790c687A1bED6186ce3624EDD9806edf9F4E);
    IERC20 private constant usdt = IERC20(0x1b901d3C9D4ce153326BEeC60e0D4A2e8a9e3cE3);

    uint dexARate = 80;
    uint dexBRate = 100;

    mapping(address => uint) public daiBalances;
    mapping(address => uint) public usdcBalances;
    mapping(address => uint) public usdtBalances;


    /*deposit functions below assumes you have already approved this contract. Logic:
    1) approve dex contract to spend a certain amount on your behalf.
    This approval is done on remix by using buttons provided by ERC20
    2) Then you can check allowance buttons to see what amount you have approved. I mean the approve() limit.
    Functions below are making sure, the allowance/approve amount is bigger than the flashloan amount.
    NOTE: The deposit functions below are not the same with sending usdc/dai to this contract by using metamask.
    Because by sending dai/usdc to contract by using metamask, we are providing some liquidity.
    Whereas the functions below are for flashloan operations. */

    /* transferFrom: for coins that we do not own. Thats why it is used with approve( and additionally allowance)
        transfer:    for coins that we own. */

    function depositUSDC(uint amount) external {
        usdcBalances[msg.sender] += amount;
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowance amount must be bigger than flashloan amount");
        usdc.transferFrom(msg.sender, address(this), amount);
    }
    function depositDAI(uint amount) external {
        daiBalances[msg.sender] += amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowance amount must be bigger than flashloan amount");
        dai.transferFrom(msg.sender, address(this), amount);
    }
    function depositUSDT(uint amount) external {
        usdtBalances[msg.sender] += amount;
        uint allowance = usdt.allowance(msg.sender, address(this));
        require(allowance >= amount, "allowance amount must be bigger than flashloan amount");
        usdt.transferFrom(msg.sender, address(this), amount);
    }

    function buyDAI() external {
        uint daiToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        dai.transfer(msg.sender, daiToReceive);
    }
    function sellDAI() external {
        uint usdcToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    function buyUSDT() external {
        uint usdtToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        usdt.transfer(msg.sender, usdtToReceive);
    }
    function sellUSDT() external {
        uint usdcToReceive = ((usdcBalances[msg.sender] / dexARate) * 100) * (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }

    function getBalance(address tokenAddress) external view returns(uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
    function withdraw(address tokenAddress, uint amount) external onlyOwner {
        IERC20 tokkie = IERC20(tokenAddress);
        tokkie.transfer(msg.sender, amount);
    }
    receive() external payable {}

}