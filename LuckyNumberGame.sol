// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract LuckyNumberGame {
    address public owner;
    uint private luckyNumber;
    uint public guessCount;\

    event GuessResult(address indexed player, uint number, bool won);
    event LuckyNumberReset(uint newNumber);

    constructor(){
        owner = msg.sender;
        luckyNumber = (block.timestamp % 10) + 1;
    }
    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function guess(uint _number) public returns(string memory){
        require(_number >=1 && _number <=  10, "Guess must be in the range of 1 - 10");
        guessCount += 1;
        if(_number == luckyNumber){
            return "You win!";
        } else{
            return "Try again!";
        }

    }
    
    function resetLuckyNumber() public onlyOwner{
        luckyNumber = (block.timestamp % 10) + 1;
        guessCount = 0;
        emit LuckyNumberReset(luckyNumber);
    }

    
}