// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TodoList{
    struct Task{
        string title;
        bool done;
    }

    mapping(uint => Task) public tasks;
    uint[] private completedTaskIds;

    function addTask(uint _id, string memory _title) public{
        tasks[_id] = Task(_title, false);
    }

    function markDone(uint _id)public{
        tasks[_id].done = true;
        completedTaskIds.push(_id);
    }

    function getTask(uint _id) public view returns(string memory , bool){
        return (tasks[_id].title, tasks[_id].done);
    }
    
    function retrieveCompleted() public view returns (uint[] memory, string[] memory) {
        uint count = completedTaskIds.length;
        string[] memory titles = new string[](count);

        for (uint i = 0; i < count; i++) {
            titles[i] = tasks[completedTaskIds[i]].title;
        }

        return (completedTaskIds, titles);
    }

}