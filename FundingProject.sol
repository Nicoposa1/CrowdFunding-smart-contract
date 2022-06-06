//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundingProject {
  string public id;
  string public name; 
  string public description;
  address payable public author;
  uint public fundingGoal;
  uint public fundingRaised;
  string public status = "Opened";

  constructor(string memory _id, string memory _name, string memory _description, uint _fundingGoal){
    id = _id;
    name = _name;
    description = _description;
    fundingGoal = _fundingGoal;
    author = payable(msg.sender);
  }

  function fundProject() payable public {
    author.transfer(msg.value);
    fundingRaised += msg.value;
  }

  function changeStatus(string calldata newStatus) public {
    status = newStatus;
  }

}