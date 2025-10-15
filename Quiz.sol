// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Quiz {
    struct Question {
        string question;
        string answer;
    }

    address public owner;
    Question[] private questions; 

    mapping(address => uint) public scores;
    mapping(address => mapping(uint => bool)) public answered; 

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this");
        _;
    }

    function addQuestion(string memory _question, string memory _answer) public onlyOwner {
        questions.push(Question(_question, _answer));
    }

    function getTotalQuestions() public view returns (uint) {
        return questions.length;
    }

    function getQuestion(uint index) public view returns (string memory) {
        require(index < questions.length, "Invalid question index");
        return questions[index].question;
    }

    function answerQuestion(uint index, string memory _answer) public returns (bool) {
        require(index < questions.length, "Question does not exist");
        require(!answered[msg.sender][index], "You already answered this question");

        answered[msg.sender][index] = true;

        if (keccak256(bytes(_answer)) == keccak256(bytes(questions[index].answer))) {
            scores[msg.sender] += 1;
            return true;
        } else {
            return false;
        }
    }

    function getScore(address user) public view returns (uint) {
        return scores[user];
    }

}
