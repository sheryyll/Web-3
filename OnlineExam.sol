// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract OnlineExam {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    mapping(address => bool) public isTeacher;
    mapping(address => bool) public isStudent;

    struct Question {
        string text;
        string[4] options;
        uint correct;
    }

    struct Exam {
        string title;
        Question[] questions;
        bool exists;
    }

    mapping(uint => Exam) public exams;
    uint public nextExamId;

    struct Submission {
        bool submitted;
        uint score;
    }

    mapping(uint => mapping(address => Submission)) public submissions;

    function addTeacher(address t) public {
        require(msg.sender == owner, "Only owner");
        isTeacher[t] = true;
    }

    function registerStudent(address s) public {
        require(msg.sender == owner, "Only owner");
        isStudent[s] = true;
    }

    function createExam(string memory title) public returns (uint) {
        require(isTeacher[msg.sender], "Only teacher");

        uint id = nextExamId;
        exams[id].title = title;
        exams[id].exists = true;

        nextExamId++;
        return id;
    }

    function addQuestion(
        uint examId,
        string memory text,
        string[4] memory options,
        uint correct
    ) public {
        require(isTeacher[msg.sender], "Only teacher");
        require(exams[examId].exists, "No exam");
        require(correct < 4, "Invalid correct");

        exams[examId].questions.push(
            Question({
                text: text,
                options: options,
                correct: correct
            })
        );
    }

    function submit(uint examId, uint[] memory answers) public {
        require(isStudent[msg.sender], "Only student");
        require(exams[examId].exists, "No exam");
        require(!submissions[examId][msg.sender].submitted, "Already submitted");

        uint qCount = exams[examId].questions.length;
        require(answers.length == qCount, "Length mismatch");

        uint score = 0;
        for (uint i = 0; i < qCount; i++) {
            if (answers[i] == exams[examId].questions[i].correct) {
                score++;
            }
        }

        submissions[examId][msg.sender] = Submission({
            submitted: true,
            score: score
        });
    }

    function getScore(uint examId, address student) public view returns (uint) {
        return submissions[examId][student].score;
    }
}
