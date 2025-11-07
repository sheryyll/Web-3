// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GamingLeaderboard {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Authorized");
        _;
    }

    struct Player {
        string name;
        uint score;
        bool registered;
    }

    mapping(address => Player) public players;
    address[] public playerAddresses;

    event PlayerRegistered(address indexed player, string name);
    event ScoreUpdated(address indexed player, uint newScore);
    event LeaderboardReset();

    function registerPlayer(string memory _name) public {
        require(!players[msg.sender].registered, "Already registered");

        players[msg.sender] = Player({
            name: _name,
            score: 0,
            registered: true
        });

        playerAddresses.push(msg.sender);
        emit PlayerRegistered(msg.sender, _name);
    }

    function updateScore(address _player, uint newScore) public onlyOwner {
        require(players[_player].registered, "Player not registered");
        players[_player].score = newScore;
        emit ScoreUpdated(_player, newScore);
    }

    function getPlayer(address _player) public view returns (string memory, uint) {
        Player memory p = players[_player];
        return (p.name, p.score);
    }

    function getTopPlayers() public view returns (Player[] memory) {
        uint count = playerAddresses.length;
        Player[] memory sorted = new Player[](count);

        for (uint i = 0; i < count; i++) {
            sorted[i] = players[playerAddresses[i]];
        }

        for (uint i = 0; i < count; i++) {
            for (uint j = 0; j < count - 1; j++) {
                if (sorted[j].score < sorted[j + 1].score) {
                    Player memory temp = sorted[j];
                    sorted[j] = sorted[j + 1];
                    sorted[j + 1] = temp;
                }
            }
        }

        return sorted;
    }

    function resetLeaderboard() public onlyOwner {
        for (uint i = 0; i < playerAddresses.length; i++) {
            players[playerAddresses[i]].score = 0;
        }
        emit LeaderboardReset();
    }
}
