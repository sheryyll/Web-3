// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CyrptoPoints{
    address public owner;
    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }
    mapping(address => uint) public points;
    
    function rewardPoints(address _user, uint _amount) public onlyOwner{
        points[_user] += _amount;
    }
    function getPoints(address _user) public view returns (uint){
        return points[_user];
    }
    function resetPoints(address _user) public onlyOwner{
        points[_user] = 0;
    }
    
}
