//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundintProject {
  struct Project {
    string id;
    string name;
    string description;
    uint fundingGoal;
    address payable author;
    string stateIs;
    uint state;
    uint fundingRaised;
  }

  Project public project;

  constructor(string memory _id, string memory _name, string memory _description, uint _fundingGoal){
    project = Project(_id, _name, _description, _fundingGoal, payable(msg.sender), "Open", 0, 0 );
  }

  event ChangeState(
    string id,
    address changer,
    uint state,
    string stateIs
  );

  event FundProject (
    string id,
    address sender,
    uint amount
  );

  modifier isNotAuthor {
    require(
      project.author == msg.sender,
      "The author can't fund the project"
    );
    _;
  }

  modifier isAuthor {
    require(
      project.author != msg.sender,
      "Only author can change the state"
    );
    _;
  }

  function fundProject() payable public isNotAuthor {
    project.author.transfer(msg.value);
    project.fundingRaised += msg.value;
    emit FundProject(project.id, msg.sender, msg.value);
  }

  function changeState(uint newState) public isAuthor {
    require(newState == 0 || newState == 1, "The state must be 0 or 1");
    require(newState != project.state, "The project is already in this state");
    if(newState == 0) {
      project.state = newState;
      project.stateIs = "Open";
    emit ChangeState(project.id, msg.sender, newState, project.stateIs);
    }else if(newState == 1) {
      project.state = newState;
      project.stateIs = "Closed";
      emit ChangeState(project.id, msg.sender, newState, project.stateIs);
    }
  }

}
