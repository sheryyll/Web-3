// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmployeeHours {
    mapping(uint => mapping(string => uint)) public workHours;

    function logHours(uint _empId, string memory _day, uint _hours) public {
        workHours[_empId][_day] += _hours;
    }

    function getHours(uint _empId, string memory _day) public view returns (uint) {
        return workHours[_empId][_day];
    }

    function getWeeklyHours(uint _empId) public view returns (uint) {
        uint total = 0;
        total += workHours[_empId]["Mon"];
        total += workHours[_empId]["Tue"];
        total += workHours[_empId]["Wed"];
        total += workHours[_empId]["Thu"];
        total += workHours[_empId]["Fri"];
        total += workHours[_empId]["Sat"];
        total += workHours[_empId]["Sun"];
        return total;
    }
}
