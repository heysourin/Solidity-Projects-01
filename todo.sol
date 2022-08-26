// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract todo{
    struct Task{
        uint taskId;
        string description;
        bool isCompleted;
    }

    mapping (uint => Task) taskAssigned;

    event taskAll(uint taskId, string description, bool isCompleted);


    function createTask(uint _taskId, string memory _description) public{
        taskAssigned[_taskId] = Task(_taskId, _description, false);
        emit taskAll(_taskId, _description, false);
    }

    function viewTask(uint _taskId) public view returns(Task memory){
        return taskAssigned[_taskId];       
        emit taskAll(_taskId);
    }

    function completeTask(uint _taskId) public {
        // taskAssigned[_taskId] = Task(_taskId, " ", true);
        taskAssigned[_taskId].isCompleted = true;
        emit taskAll({taskId: _taskId,description:, isCompleted: true});
    }
}
