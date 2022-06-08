//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract FundingProject {
  string public id;
  string public name;
  string public description;
  uint public state = 0;
  string public stateIs = "Open";
  address payable public author;
  uint256 public fundingGoal;
  uint256 public fundingRaised;

  constructor(
    string memory _id,
    string memory _name,
    string memory _description,
    uint256 _fundingGoal
  ) {
    id = _id;
    name = _name;
    description = _description;
    fundingGoal = _fundingGoal;
    author = payable(msg.sender);
  }

  event FundProject(
    string id,
    address sender,
    uint256 amount
  );

  event ChangeStatus(
    string id,
    address changer,
    uint newStatus,
    string stateIs
  );

  modifier isAuthor() {
    require(author == msg.sender, "Only the author can do this");
    _;
  }

  modifier isNotAuthor() {
    require(author != msg.sender, "The author cannot do this");
    _;
  }

  function fundProject() public payable {
    require(state == 0, "The project is closed");
    author.transfer(msg.value);
    fundingRaised += msg.value;
    emit FundProject(id, msg.sender, msg.value);
  }

  function changeStatus(uint newState) public {
    require(newState == 0 && newState != state || newState == 1 && newState == state, "The state is alredy defined");
    if(newState == 0) {
      state = newState;
      stateIs = "Open";
      emit ChangeStatus(id, msg.sender, newState, stateIs);
    } else if(newState == 1) {
      state = newState;
      stateIs = "Closed";
      emit ChangeStatus(id, msg.sender, newState, stateIs);
    }
  }
}
