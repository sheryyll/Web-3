// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TokenCounter {
    
    event Transfer(address indexed from, address indexed to, uint amount);

    string public name = "MiniToken";
    string public symbol = "MTK";
    uint public totalSupply = 1000;
    uint8 public decimals = 18;

    address public owner;

    mapping(address => uint) public balances;

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    function transfer(address _to, uint _amount) public {
        require(_to != address(0), "Cannot transfer to zero address");
        require(balances[msg.sender] >= _amount, "Not enough balance");

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
    }

    function getBalance(address _user) public view returns(uint) {
        return balances[_user];
    }

    function mint(uint _amount) public onlyOwner {
        totalSupply += _amount;
        balances[owner] += _amount;
        emit Transfer(address(0), owner, _amount);
    }

    function burn(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Not enough balance");

        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }
}
