//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AllowanceTracker{
    address public owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not the owner");
        _;
    }

    struct Allowance{
        uint amount;
        uint spent;
    }
    mapping(address => Allowance) public allowances;
    event AllowanceSet(address indexed child, uint amount);
    event AllowanceWithdrawn(address indexed child, uint amount);
    event Deposit(address indexed from, uint amount);
    event WithdrawAll(address indexed owner, uint amount);

    function setAllowance(address _child, uint _amount) public onlyOwner{
        require(_amount>0, "Amount must be greater than zero");
        allowances[_child] = Allowance(_amount, 0);
        emit AllowanceSet(_child, _amount);
    }

    function deposit() public payable onlyOwner {
        require(msg.value > 0, "Must send some Ether");
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint _amount) public {
        Allowance storage allowance = allowances[msg.sender];
        require(_amount > 0, "Amount must be greater than zero");
        require(
            allowance.amount - allowance.spent >= _amount,
            "Insufficient allowance"
        );
        require(address(this).balance >= _amount, "Contract balance too low");

        allowance.spent += _amount;
        payable(msg.sender).transfer(_amount);
        emit AllowanceWithdrawn(msg.sender, _amount);
    }

    function withdrawAll() public onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(owner).transfer(balance);
        emit WithdrawAll(owner, balance);
    }

    function getAllowance(address _child) public view returns(uint){
        return allowances[_child].amount - allowances[_child].spent;
    }

    function getContractBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }

}