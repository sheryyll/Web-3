// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MiniAuction{
    address public owner;
    uint public highestBid;
    address public highestBidder;

    constructor(){
        owner = msg.sender;
    }

    event NewBid( address  indexed bidder, uint amount);

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function bid() public payable{
        require(msg.value > highestBid, "Bid must be higher than current highest");
        highestBid = msg.value;
        highestBidder = msg.sender;
        emit NewBid(msg.sender, msg.value);
    }

    function endAuction() public onlyOwner{
        require(highestBid > 0, "No bids placed yet");
        payable(owner).transfer(highestBid);

    }


}