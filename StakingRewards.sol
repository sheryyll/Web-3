// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract StakingRewards {
    address public owner;
    uint public rewardRate;
    uint public totalStaked;
    uint public lockPeriod;

    struct StakeInfo {
        uint amount;
        uint rewardClaimed;
        uint depositTime;
        uint lastClaimTime;
        bool active;
        uint compoundingFactor;
    }

    mapping(address => StakeInfo) public stakes;

    event Staked(address indexed user, uint amount, uint totalStaked);
    event RewardClaimed(address indexed user, uint amount, uint timestamp);
    event Withdrawn(address indexed user, uint amount, uint timestamp);
    event RewardRateUpdated(uint newRate);
    event LockPeriodChanged(uint newPeriod);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
        rewardRate = 5e14;
        lockPeriod = 7 days;
    }

    function stake() public payable {
        require(msg.value > 0, "Stake amount must be greater than zero");
        StakeInfo storage userStake = stakes[msg.sender];
        if (userStake.active) {
            uint pending = calculateReward(msg.sender);
            userStake.amount += msg.value;
            userStake.lastClaimTime = block.timestamp;
            userStake.rewardClaimed += pending;
        } else {
            stakes[msg.sender] = StakeInfo({
                amount: msg.value,
                rewardClaimed: 0,
                depositTime: block.timestamp,
                lastClaimTime: block.timestamp,
                active: true,
                compoundingFactor: 1
            });
        }
        totalStaked += msg.value;
        emit Staked(msg.sender, msg.value, totalStaked);
    }

    function calculateReward(address user) public view returns (uint) {
        StakeInfo storage s = stakes[user];
        if (!s.active || s.amount == 0) return 0;
        uint duration = block.timestamp - s.lastClaimTime;
        uint reward = (s.amount * rewardRate * duration) / 1e18;
        reward *= s.compoundingFactor;
        return reward;
    }

    function claimReward() public {
        StakeInfo storage s = stakes[msg.sender];
        require(s.active, "No active stake");
        uint reward = calculateReward(msg.sender);
        require(reward > 0, "No rewards to claim");
        require(address(this).balance >= reward, "Insufficient contract balance");

        s.rewardClaimed += reward;
        s.lastClaimTime = block.timestamp;

        payable(msg.sender).transfer(reward);

        emit RewardClaimed(msg.sender, reward, block.timestamp);
    }

    function withdraw(uint amount) public {
        StakeInfo storage s = stakes[msg.sender];
        require(s.active && s.amount >= amount, "Invalid withdrawal");
        require(block.timestamp >= s.depositTime + lockPeriod, "Locked period not over");

        claimReward();
        s.amount -= amount;
        totalStaked -= amount;

        if (s.amount == 0) s.active = false;

        payable(msg.sender).transfer(amount);

        emit Withdrawn(msg.sender, amount, block.timestamp);
    }

    function updateRewardRate(uint newRate) public onlyOwner {
        rewardRate = newRate;
        emit RewardRateUpdated(newRate);
    }

    function setLockPeriod(uint newPeriod) public onlyOwner {
        lockPeriod = newPeriod;
        emit LockPeriodChanged(newPeriod);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {}
}
