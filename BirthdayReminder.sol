// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract BirthdayReminder {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    struct Birthday {
        string name;
        uint day;
        uint month;
    }

    mapping(address => Birthday) private birthdays;

    event BirthdayAdded(address indexed user, string name, uint day, uint month);
    event BirthdayUpdated(address indexed user, string name, uint day, uint month);

    function saveBirthday(string memory _name, uint _day, uint _month) public {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(_day > 0 && _day <= 31, "Day must be between 1 and 31");
        require(_month > 0 && _month <= 12, "Month must be between 1 and 12");

        bool exists = bytes(birthdays[msg.sender].name).length > 0;

        birthdays[msg.sender] = Birthday(_name, _day, _month);

        if (exists) {
            emit BirthdayUpdated(msg.sender, _name, _day, _month);
        } else {
            emit BirthdayAdded(msg.sender, _name, _day, _month);
        }
    }

    function getBirthday(address _user) public view returns (string memory, uint, uint) {
        Birthday memory birthday = birthdays[_user];
        return (birthday.name, birthday.day, birthday.month);
    }

    function isBirthdayToday(address _user) public view returns (bool) {
        Birthday memory birthday = birthdays[_user];
        (uint day, uint month) = _getCurrentDayAndMonth();
        return birthday.day == day && birthday.month == month;
    }

    function clearBirthdays(address[] memory users) public onlyOwner {
        for (uint i = 0; i < users.length; i++) {
            delete birthdays[users[i]];
        }
    }

    function _getCurrentDayAndMonth() internal view returns (uint day, uint month) {
        uint timestamp = block.timestamp;
        uint SECONDS_PER_DAY = 24 * 60 * 60;
        uint daysSinceEpoch = timestamp / SECONDS_PER_DAY;

        uint year = 1970 + daysSinceEpoch / 365;
        uint leapYears = (year - 1969) / 4;
        uint dayOfYear = daysSinceEpoch - ((year - 1970) * 365 + leapYears);

        uint256[12] memory monthDays = [uint256(31), uint256(28), uint256(31), uint256(30), uint256(31), uint256(30), uint256(31), uint256(31), uint256(30), uint256(31), uint256(30), uint256(31)];
        
        
        if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
            monthDays[1] = 29;
        }

        month = 1;
        while (dayOfYear >= monthDays[month-1]) {
            dayOfYear -= monthDays[month-1];
            month++;
        }
        day = dayOfYear + 1;
    }
}
