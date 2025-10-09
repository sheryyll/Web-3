// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleVote{
    uint public voteCount;

    mapping(address => bool) public hasVoted;

    function  vote() public{
         require(!hasVoted[msg.sender], "You have already voted!");
        hasVoted[msg.sender] = true;
        voteCount++;
    }

    function checkVote( address _voter) public view returns(bool){
        return hasVoted[_voter];
    }
}
