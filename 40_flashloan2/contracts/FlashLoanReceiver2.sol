// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.1;

import "./FlashLoan.sol";

contract FlashLoanReceiver {
    FlashLoan public pool;

    address public owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "you are not owner");
        _;
    }

    event LoanReceived(address token, uint amount);

    constructor(address _tokenAddress) {
        pool = FlashLoan(_tokenAddress);
        owner = msg.sender;
    }

    function receiveTokens(address _tokenAddress, uint _amount) external {
        emit LoanReceived(_tokenAddress, _amount);
        //do stuff with the money
        //return funds to the pool
        require(Token(_tokenAddress).transfer(msg.sender, _amount), "transfer funds back");
    }

    function executeFlashLoan(uint _amount) external onlyOwner {
        pool.flashLoan(_amount);
    }
}

contract AaveFlashloan is FlashLoanSimpleReceiverBase {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    constructor(IPoolAddressesProvider provider)
        FlashLoanSimpleReceiverBase(provider)
    {}

    function aaveFlashloan(address loanToken, uint256 loanAmount) external {
        IPool(address(POOL)).flashLoanSimple(
            address(this),
            loanToken,
            loanAmount,
            "0x",
            0
        );
    }
    
    // import "Token.sol";
    Token public token = Token(0x05714B0c537E685dbe4E5Cda1E6CA934e40c0588);
    function receiveTokens(address _tokenAddress, uint _amount) external {
        require(msg.sender == address(pool), "only pool can call this function");
        require(Token(_tokenAddress).balanceOf(address(this)) == _amount, "receive xxx");
        emit LoanReceived(_tokenAddress, _amount);
        //do stuff with the money
        //return funds to the pool
        require(Token(_tokenAddress).transfer(msg.sender, _amount), "transfer funds back");
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address, bytes memory) public override returns (bool) {
        require( amount <= IERC20(asset).balanceOf(address(this)), "Invalid balance");
        // pay back the loan amount and the premium (flashloan fee)
        uint256 amountToReturn = amount.add(premium);
        require(IERC20(asset).balanceOf(address(this)) >= amountToReturn, "Not enough amount to return loan");
        approveToken(asset, address(POOL), amountToReturn);
        return true;
    }

    function executeOperation(address asset, uint256 amount, uint256 premium, address, bytes memory) public override returns (bool) {
        require( amount <= IERC20(asset).balanceOf(address(this)), "Invalid balance");
        // pay back the loan amount and the premium (flashloan fee)
        uint256 amountToReturn = amount.add(premium);
        require(IERC20(asset).balanceOf(address(this)) >= amountToReturn, "Not enough amount to return loan");
        approveToken(asset, address(POOL), amountToReturn);
        return true;
    }

    function approveToken(address token, address to, uint256 amountIn) internal {
        require(IERC20(token).approve(to, amountIn), "approve failed");
    }
}
