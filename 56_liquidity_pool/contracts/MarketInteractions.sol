// SPDX-License-Identifier: MIT
pragma solidity >=0.8.10;

import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/*
import {IPool} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol";
import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "https://github.com/aave/aave-v3-core/blob/master/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
 */


contract MarketInteractinos {
    error OwnerError(string message, address caller);
    address payable public owner;
    modifier onlyOwner(){
        if (msg.sender != owner) {
            revert OwnerError("you are not owner", msg.sender);
        }
        _;
    }
    
    IPoolAddressesProvider public immutable ADDRESS_PROVIDER;
    IPool public immutable POOL;

    address private constant linkAddress =  0x07C725d58437504CA5f814AE406e70E21C5e8e9e;
    IERC20 private link = IERC20(0x42Dc50EB0d35A62eac61f4E4Bc81875db9F9366e);

    constructor(address _addressProvider) {
        ADDRESS_PROVIDER = IPoolAddressesProvider(_addressProvider);
        POOL = IPool(ADDRESS_PROVIDER.getPool());
        owner = payable(msg.sender);
    }

    function supplyLiquidity(address _tokenAddress, uint _amount) external onlyOwner {
         address asset = _tokenAddress; //token that we want to supply
         uint amount = _amount;
         address onBehalfOf = address(this); //we will not use this. We gave random value
         uint16 referralCode = 0;
        POOL.supply(asset, amount, onBehalfOf, referralCode);
    }

    function withdrawLiquidity(address _tokenAddress, uint _amount) external onlyOwner returns(uint) {
        address asset = _tokenAddress;
        uint amount = _amount;
        address to = address(this);
        return POOL.withdraw(asset, amount, to);
    }

    function getMyData(address _userAddress) external view onlyOwner returns(
        uint totalCollateralBase,
        uint totalDebtBase,
        uint availableBorrowsBase,
        uint currentLiquidationThreshold,
        uint ltv,
        uint healthFactor
    ) {
        return POOL.getUserAccountData(_userAddress);
    }
    //standard functions set:

    receive() external payable {}

    function getBalance(address tokenAddress) external view onlyOwner returns(uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
    function withdraw(address tokenAddress, uint amount) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, amount);
    }

    function approvePool(uint _amount, address _poolAddress) external returns(bool){
        return link.approve(_poolAddress, _amount);
    }

    function allowanceCheck(address _poolAddress) external view returns(uint) {
        return link.allowance(address(this), _poolAddress);
    }

}
