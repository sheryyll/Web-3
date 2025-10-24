// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StudentFeeSystem {
    address public owner;
    mapping(address => uint) public studentFees;
    uint public totalFeesCollected;

    event FeesPaid(address indexed student, uint amount);
    event FeesWithdrawn(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    function payFees() public payable {
        require(msg.value > 0, "Fees must be greater than 0");
        studentFees[msg.sender] += msg.value;
        totalFeesCollected += msg.value;
        emit FeesPaid(msg.sender, msg.value);
    }

    function withdrawFees(uint _amount) public onlyOwner {
        require(_amount <= address(this).balance, "Insufficient contract balance");
        payable(owner).transfer(_amount);
        totalFeesCollected -= _amount;
        emit FeesWithdrawn(owner, _amount);
    }

    function getStudentFees(address _student) public view returns (uint) {
        return studentFees[_student];
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    receive() external payable {
        studentFees[msg.sender] += msg.value;
        totalFeesCollected += msg.value;
        emit FeesPaid(msg.sender, msg.value);
    }
}
