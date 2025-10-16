// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Subscription{
    mapping(address => bool) public subscribers;
    uint public subscriptionFee = 0.01 ether;

    function subscribe () public payable{
        require( msg.value == subscriptionFee, "Incorrect subscription fee");
        subscribers[msg.sender] = true;
    }

    function unsubscribe() public{
        subscribers[msg.sender] = false;
    }

    function isSubscribed(address _user) public view returns(bool){
        return subscribers[_user];
    }
}