// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MiniSolidity {
    address public owner;
    uint public minBet;
    uint public maxBet;
    uint public houseEdgePercent;

    constructor(uint _minBet, uint _maxBet) {
        owner = msg.sender;
        minBet = _minBet;
        maxBet = _maxBet;
        houseEdgePercent = 2;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only authorized users have access");
        _;
    }

    struct Player {
        uint totalGames;
        uint totalWon;
        uint totalLost;
    }

    mapping(address => Player) public players;

    event GamePlayed(address indexed player, bool win, uint betAmount, uint randomNumber);
    event FundsAdded(address indexed owner, uint amount, uint newBalance);
    event FundsWithdrawn(address indexed owner, uint amount);

    function placeBet() public payable {
        require(msg.value > 0, "Some Ether is required to place bet");
        require(msg.value >= minBet && msg.value <= maxBet, "Invalid bet amount");
        require(address(this).balance >= msg.value * 2, "Not enough contract balance to cover potential winnings");

        uint randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.prevrandao, msg.sender))
        ) % 2;

        Player storage player = players[msg.sender];
        player.totalGames++;

        if (randomNumber == 1) {
            uint winningAmount = (msg.value * (100 - houseEdgePercent)) / 100;
            player.totalWon += winningAmount;
            payable(msg.sender).transfer(winningAmount);
            emit GamePlayed(msg.sender, true, msg.value, randomNumber);
        } else {
            player.totalLost += msg.value;
            emit GamePlayed(msg.sender, false, msg.value, randomNumber);
        }
    }

    function getPlayerStats(address _player) public view returns (uint, uint, uint) {
        Player storage player = players[_player];
        return (player.totalGames, player.totalWon, player.totalLost);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getWinRate(address _player) public view returns (uint) {
        Player storage player = players[_player];
        if (player.totalGames == 0) return 0;
        return (player.totalWon * 100) / player.totalGames;
    }

    function fundCasino() external payable onlyOwner {
        require(msg.value > 0, "Funding amount must be greater than zero");
        emit FundsAdded(owner, msg.value, address(this).balance);
    }

    function withdrawFunds(uint amount) external onlyOwner {
        require(amount <= address(this).balance, "Amount withdrawal cannot exceed contract balance");
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }

    receive() external payable {}
    fallback() external payable {}
}
