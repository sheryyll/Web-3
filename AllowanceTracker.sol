//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Parent{
    address public owner;

    constructor() {
        owner = msg.sender;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
}

contract AllowanceManager is Parent{
    event AllowanceAssigned(address indexed child, uint amount);
    event AllowanceSpent(address indexed spender, uint amount);
    mapping(address => uint) public balances;

    function assignAllowance(address _child, uint _amount) public onlyOwner {
        require(_child != address(0), "Invalid child address");
        require(_amount > 0, "Allowance must be greater than zero");
        balances[_child] += _amount;
        emit AllowanceAssigned(_child, _amount);
    }

    function spendAllowance(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough allowance");
        balances[msg.sender] -= _amount;
        emit AllowanceSpent(msg.sender, _amount);
    }

    function getBalance(address _child) public view returns(uint){
        return balances[_child];
    }

    function getMyBalance() public view returns(uint){
        return balances[msg.sender];
    }

}