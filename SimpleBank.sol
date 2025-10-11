// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleBank{
    mapping(address => uint) private balances;

    function deposit() public payable{
        require(msg.value > 0, "Deposit amount must be greater than zero");
        balances[msg.sender] += msg.value;
    }
    function withdraw(uint _amount) public{
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }
    function checkBalance() public view returns (uint){
        return balances[msg.sender];
    }
}