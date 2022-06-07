//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract FundingProject {
  string public id;
  string public name;
  string public description;
  string public status = "Open";
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
    address sender,
    uint256 amount
  );

  event ChangeStatus(
    address changer,
    string newStatus
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
    author.transfer(msg.value);
    fundingRaised += msg.value;
    emit FundProject(msg.sender, msg.value);
  }

  function changeStatus(string calldata newStatus) public {
    status = newStatus;
    emit ChangeStatus(msg.sender, newStatus);
  }
}
