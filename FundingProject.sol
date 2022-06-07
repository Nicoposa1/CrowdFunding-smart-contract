//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundingProject {
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

    modifier onlyAuthor() {
        require(author == msg.sender, "Only author can do this");
        _;
    }

    modifier authorNotDo() {
        require(author != msg.sender, "The author can't fund this project");
        _;
    }

    function fundProject() public payable {
        author.transfer(msg.value);
        fundingRaised += msg.value;
    }

    function changeStatus(string calldata newStatus) public {
        status = newStatus;
    }
}
