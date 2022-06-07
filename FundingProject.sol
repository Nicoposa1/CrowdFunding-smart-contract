//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundingProject {
  string public id;
  string public name;
  string public description;
  address payable public author;
  uint public fundingGoal;
  uint public fundingRaised;
  string public status = "Open";


  constructor(string memory _id, string memory _name, string memory _description, uint _fundingGoal)  { 
    id = _id;
    name = _name;
    description = _description;
    author = payable(msg.sender);
    fundingGoal = _fundingGoal;
  }

  modifier onlyOwner() {
    require(
      msg.sender == author,
      "Only owner can do this"
    );
    _;
  }

  modifier ownerNotdo(){
    require(
      msg.sender != author,
      "The author can't do this"
    );
    _;
  }

  function fundProject() payable public ownerNotdo {
    author.transfer(msg.value);
    fundingRaised += msg.value;
  }

  function changeStatus(string calldata newStatus) public onlyOwner {
    status = newStatus;
  }

}

