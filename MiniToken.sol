// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MiniToken {
    event Transfer(address indexed from, address indexed to, uint amount);
    event Mint(address indexed to, uint amount);

    struct Token {
        string name;
        uint totalSupply;
    }

    mapping(address => uint) public balances;
    address public owner;

    modifier ownerOnly() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender; 
    }

    function mint(address _to, uint _amount) public ownerOnly {
        balances[_to] += _amount;
        emit Mint(_to, _amount);
    }

    function transfer(address _to, uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[_to] += amount;
        emit Transfer(msg.sender, _to, amount);
    }

    function getBalance(address _user) public view returns (uint) {
        return balances[_user];
    }
}
