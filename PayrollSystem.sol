// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract PayrollSystem {
    address public owner;

    struct Employee {
        string name;
        uint salary;
        uint lastPaid;
        bool active;
    }

    mapping(address => Employee) public employees;
    address[] public employeeList;

    event EmployeeAdded(address employee, string name, uint salary);
    event EmployeeRemoved(address employee);
    event SalaryPaid(address employee, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addEmployee(address _employee, string memory _name, uint _salary) public onlyOwner {
        require(!employees[_employee].active, "Already added");
        employees[_employee] = Employee(_name, _salary, 0, true);
        employeeList.push(_employee);
        emit EmployeeAdded(_employee, _name, _salary);
    }

    function removeEmployee(address _employee) public onlyOwner {
        require(employees[_employee].active, "Not active");
        employees[_employee].active = false;
        emit EmployeeRemoved(_employee);
    }

    function deposit() public payable onlyOwner {}

    function payEmployee(address _employee) public onlyOwner {
        Employee storage emp = employees[_employee];
        require(emp.active, "Not active");
        require(address(this).balance >= emp.salary, "Not enough balance");

        emp.lastPaid = block.timestamp;
        payable(_employee).transfer(emp.salary);

        emit SalaryPaid(_employee, emp.salary);
    }

    function getEmployee(address _employee) public view returns (string memory, uint, uint, bool) {
        Employee memory emp = employees[_employee];
        return (emp.name, emp.salary, emp.lastPaid, emp.active);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {}
}
