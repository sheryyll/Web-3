// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract AttendanceManager {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized: Owner only");
        _;
    }

    modifier onlyTeacher() {
        require(isTeacher[msg.sender], "Not authorized: Teacher only");
        _;
    }

    struct AttendanceRecord {
        uint totalDays;
        uint daysPresent;
        bool isStudent;
    }

    mapping(address => AttendanceRecord) public attendanceRecords;
    mapping(address => bool) public isTeacher;

    event StudentRegistered(address indexed student);
    event TeacherAdded(address indexed teacher);
    event TeacherRemoved(address indexed teacher);
    event AttendanceMarked(address indexed student, bool present);
    event AttendanceReset(address indexed student);

    function registerStudent(address student) public onlyOwner {
        require(!attendanceRecords[student].isStudent, "Student already registered");
        attendanceRecords[student] = AttendanceRecord(0, 0, true);
        emit StudentRegistered(student);
    }

    function addTeacher(address teacher) public onlyOwner {
        require(!isTeacher[teacher], "Teacher already added");
        isTeacher[teacher] = true;
        emit TeacherAdded(teacher);
    }

    function removeTeacher(address teacher) public onlyOwner {
        require(isTeacher[teacher], "Teacher not found");
        isTeacher[teacher] = false;
        emit TeacherRemoved(teacher);
    }

    function markPresent(address student) public onlyTeacher {
        require(attendanceRecords[student].isStudent, "Not a registered student");
        attendanceRecords[student].totalDays += 1;
        attendanceRecords[student].daysPresent += 1;
        emit AttendanceMarked(student, true);
    }

    function markAbsent(address student) public onlyTeacher {
        require(attendanceRecords[student].isStudent, "Not a registered student");
        attendanceRecords[student].totalDays += 1;
        emit AttendanceMarked(student, false);
    }

    function getAttendance(address student)
        public
        view
        returns (uint totalDays, uint daysPresent)
    {
        require(attendanceRecords[student].isStudent, "Not a registered student");
        AttendanceRecord memory record = attendanceRecords[student];
        return (record.totalDays, record.daysPresent);
    }

    function getAttendancePercentage(address student)
        public
        view
        returns (uint percentage)
    {
        require(attendanceRecords[student].isStudent, "Not a registered student");
        AttendanceRecord memory record = attendanceRecords[student];
        if (record.totalDays == 0) return 0;
        return (record.daysPresent * 100) / record.totalDays;
    }

    function isTeacherAddress(address teacher) public view returns (bool) {
        return isTeacher[teacher];
    }

    function resetAttendance(address student) public onlyOwner {
        require(attendanceRecords[student].isStudent, "Not a registered student");
        attendanceRecords[student].totalDays = 0;
        attendanceRecords[student].daysPresent = 0;
        emit AttendanceReset(student);
    }
}
