// SPDX// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Counter{
    uint public count = 0;

    function increment() public{
        count += 1;
    }

    function decrement() public{
        require(count > 0, "Count cannot go below zero");
        count -= 1;
    }

    function reset() public{
        count = 0;
    }
    
    function getCount() public view returns(uint){
        return count;
    }

}