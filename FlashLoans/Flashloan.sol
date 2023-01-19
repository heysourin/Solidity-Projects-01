// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";
import "./token.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}

contract Flashloan is ReentrancyGuard {
    using SafeMath for uint256;

    Token public token;
    uint256 public poolBalance;

    constructor(address tokenAddress) {
        require(tokenAddress != address(0), "Token address can't be zero");
        token = Token(tokenAddress);
    }

    function depositTokens(uint256 amount) external nonReentrant {
        require(amount > 0, "Must deposit atleast one token");
        token.transferFrom(msg.sender, address(this), amount);
        poolBalance = poolBalance.add(amount);
    }

    function flashLoan(uint256 brrowAmount) external nonReentrant {
        require(brrowAmount > 0, "Must borrow atleast one token");

        uint256 balanceBefore = token.balanceOf(address(this));
        require(balanceBefore >= brrowAmount, "Not enough tokens in the pool");

        assert(poolBalance == balanceBefore);

        token.transfer(msg.sender, brrowAmount);

        IReceiver(msg.sender).receiveTokens(address(token), brrowAmount);

        uint256 balanceAfter = token.balanceOf(address(this));
        require(
            balanceAfter >= balanceBefore,
            "Flashloan has not been paid back"
        );
    }
}
