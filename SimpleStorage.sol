// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract SimpleStorage{
    uint myNumber;
    string myName;

    function setMyNumber(uint _num) public{
        myNumber = _num;
    }

    function getMyNumber() public view returns(uint){
        return myNumber;
    }

    function setMyName(string memory _name) public{
        myName = _name; 
    }

    function getMyName() public view returns(string memory){
        return myName;
    }

    function getLengthOfName() public view returns(uint) {
        return bytes(myName).length;
    }
}
