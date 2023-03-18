//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract SimpleAuction {
    address payable public beneficiary;
    uint256 public auctionEndTime;

    // Current state of the auction.
    address public highestBidder;
    uint256 public highestBid;

    mapping(address => uint256) pendingReturns; // Allows withdrawals of previous bids, when next bidder bids higher

    bool ended; // Set to true at the end, disallows any change.By default initialized to `false`.

    error AuctionAlreadyEnded();
    error BidNotHighEnough(uint256 highestBid); // There is already a higher or equal bid.

    error AuctionNotYetEnded();
    error AuctionEndAlreadyCalled();

    constructor(uint256 biddingTime, address payable beneficiaryAddress) {
        beneficiary = beneficiaryAddress;
        auctionEndTime = block.timestamp + biddingTime;
    }

    function bid() external payable {
        if (block.timestamp > auctionEndTime) revert AuctionAlreadyEnded();

        if (msg.value <= highestBid) revert BidNotHighEnough(highestBid);

        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    //Have to be the msg.sender to withdraw your claimed amount
    function withdraw() external returns (bool) {
        uint256 amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;
        }

        if (!payable(msg.sender).send(amount)) {
            pendingReturns[msg.sender] = amount; //so that the bidder can try to withdraw their funds again later, if transfer fails.
            return false;
        }
        return true;
    }

    function auctionEnd() external {
        // 1. Conditions
        if (block.timestamp < auctionEndTime) revert AuctionNotYetEnded();
        if (ended) revert AuctionEndAlreadyCalled();

        // 2. Effects
        ended = true;

        // 3. Interaction
        beneficiary.transfer(highestBid);
    }
}
