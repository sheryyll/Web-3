// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MiniPoll {
    struct Option {
        string name;
        uint votes;
    }

    address public owner;
    Option[] public options;
    mapping(address => bool) public hasVoted;

    event OptionAdded(string name);
    event Voted(address voter, string optionName);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addOption(string memory _name) public onlyOwner {
        options.push(Option(_name, 0));
        emit OptionAdded(_name);
    }

    function vote(uint _index) public {
        require(!hasVoted[msg.sender], "You have already voted.");
        require(_index < options.length, "Invalid option index.");
        options[_index].votes += 1;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, options[_index].name);
    }

    function getOptions() public view returns (Option[] memory) {
        return options;
    }

    function getWinningOption() public view returns (string memory winner, uint votes) {
        require(options.length > 0, "No options available.");
        uint highestVotes = 0;
        uint winningIndex = 0;
        for (uint i = 0; i < options.length; i++) {
            if (options[i].votes > highestVotes) {
                highestVotes = options[i].votes;
                winningIndex = i;
            }
        }
        return (options[winningIndex].name, highestVotes);
    }
}
