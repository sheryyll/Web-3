//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityFund {
    address public owner;
    uint public totalFunds;
    uint public donationCount;

    mapping(address => uint) public donations;

    event DonationReceived(address indexed donor, uint amount);
    event FundsWithdrawn(address indexed recipient, uint amount);
    event FundAllocated(address indexed receiver, uint amount, string purpose);

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    function donate() public payable{
        require(msg.value > 0, "donation amount must be greater than zero");
        donations[msg.sender] += msg.value;
        totalFunds += msg.value;
        donationCount += 1;
        emit DonationReceived(msg.sender, msg.value);
    }

    function withdrawAll() public onlyOwner {
        uint amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");
        payable(owner).transfer(amount);
        totalFunds = 0;
        emit FundsWithdrawn(owner, amount);
    }


    function allocateFunds(address receiver, uint amount, string memory purpose) public onlyOwner {
        require( amount <= totalFunds, "Insufficient funds" );
        totalFunds -= amount;
        payable(receiver).transfer(amount);
        emit FundAllocated(receiver, amount, purpose);
    }

    function getDonationsOf(address donor) public view returns (uint) {
        return donations[donor];
    }

    function getTotalFunds() public view returns (uint) {
        return totalFunds;
    }

    function getDonationCount() public view returns (uint) {
        return donationCount;
    }

    receive() external payable {
        donate();
    }

    fallback() external payable {
        revert("Use donate() to send funds");
    }





}