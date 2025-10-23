// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract School {
    address public owner;
    string public schoolName;

    event SchoolNameChanged(string oldName, string newName);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function setSchoolName(string memory _name) public onlyOwner {
        string memory oldName = schoolName;
        schoolName = _name;
        emit SchoolNameChanged(oldName, _name);
    }
}

contract Teacher is School {
    struct Student {
        string name;
        uint marks;
        bool exists;
    }

    mapping(address => Student) public students;
    uint public studentCount;

    event StudentAdded(address student, string name);
    event MarksAssigned(address student, uint marks);
    event StudentNameUpdated(address student, string oldName, string newName);

    function addStudent(address _student, string memory _name) public onlyOwner {
        require(!students[_student].exists, "Student already exists");
        students[_student] = Student(_name, 0, true);
        studentCount += 1;
        emit StudentAdded(_student, _name);
    }

    function assignMarks(address _student, uint _marks) public onlyOwner {
        require(students[_student].exists, "Student does not exist");
        students[_student].marks = _marks;
        emit MarksAssigned(_student, _marks);
    }

    function updateStudentName(address _student, string memory _newName) public onlyOwner {
        require(students[_student].exists, "Student does not exist");
        string memory oldName = students[_student].name;
        students[_student].name = _newName;
        emit StudentNameUpdated(_student, oldName, _newName);
    }

    function getStudent(address _student) public view returns (string memory, uint) {
        require(students[_student].exists, "Student does not exist");
        return (students[_student].name, students[_student].marks);
    }
}
