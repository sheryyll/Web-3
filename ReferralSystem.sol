//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReferralSystem {
    address public owner;
    uint public rewardRate;

    mapping(address => address) public referrerOf;
    mapping(address => uint) public rewards;

    event RewardRateUpdated(uint oldRate, uint newRate);
    event UserReferred(address indexed user, address indexed referrer);
    event RewardEarned(address indexed referrer, address indexed referee, uint amount);
    event RewardWithdrawn(address indexed referrer, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function setRewardRate(uint newRate) public onlyOwner {
        uint oldRate = rewardRate;
        rewardRate = newRate;
        emit RewardRateUpdated(oldRate, newRate);
    }   

    function register(address referrer) public{
        require(referrer != address(0), "Invalid referrer");
        require( referrer != msg.sender, "Cannot refer yourself");
        require( referrerOf[msg.sender] == address(0), "Referrer already set");
        
        referrerOf[msg.sender] = referrer;
        emit UserReferred(msg.sender, referrer);
    }

    function makePurchase() public payable{
        require(msg.value > 0, "Purchase amount must be greater than zero");
        
        address referrer = referrerOf[msg.sender];
        if(referrer !=address(0)){
            uint reward = (msg.value * rewardRate) / 10000;
            rewards[referrer] += reward;
            emit RewardEarned(referrer, msg.sender, reward);
        }
    }

    function withdrawRewards() public {
        uint amount = rewards[msg.sender];
        require(amount > 0, "No rewards to withdraw");

        rewards[msg.sender] = 0;
        payable(msg.sender).transfer(amount); // ✅ Send Ether
        emit RewardWithdrawn(msg.sender, amount);
    }

    function deposit() public payable onlyOwner {
        require(msg.value > 0, "Deposit amount must be greater than zero");
    }

    function withdrawAll() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");

        payable(owner).transfer(balance);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getReferrer(address user) public view returns(address){
        return referrerOf[user];
    }

    function getRewardBalance(address referrer) public view returns(uint){
        return rewards[referrer];
    }


    
}