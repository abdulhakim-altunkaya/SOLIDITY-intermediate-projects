//SDPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

contract Dex {
    address payable public owner;

    IERC20 private dai = IERC20(0xDF1742fE5b0bFc12331D8EAec6b478DfDbD31464);
    IERC20 private usdc = IERC20(0xA2025B15a1757311bfD68cb14eaeFCc237AF5b43);

    uint dexARate = 90;
    uint dexBRate = 100;

    mapping(address => uint) public daiBalances;
    mapping(address => uint) public usdcBalances;

    constructor() {
        owner = payable(msg.sender);
    }

    function depositUSDC(uint amount) external {
        usdcBalances[msg.sender] += amount;
        //I am allowing this contract, then I am sending the funds. I am not sure if I have to allow it before sending the funds.
        uint allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token allowance");
        usdc.transferFrom(msg.sender, address(this), amount);
    }
    function depositDAI(uint amount) external {
        daiBalances[msg.sender] += amount;
        uint allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= amount, "check the token allowance");
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

    function getBalance(address _tokenAddress) external view returns (uint) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    receive() external payable {}
}





    