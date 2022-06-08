//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundingProject {
    string public id;
    string public name;
    string public description;
    string public stateIs = "Open";
    uint256 public state = 0;
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

    event FundProject(string id, address sender, uint256 amount);

    event ChangeState(
        string id,
        address changer,
        string stateIs,
        uint256 state
    );

    modifier isNotAuthor() {
        require(author != msg.sender, "The author can't fund your own project");
        _;
    }

    modifier isAuthor() {
        require(author == msg.sender, "Only author can do this");
        _;
    }

    function fundProject() public payable isNotAuthor {
        require(state == 0, "The project is closed");
        require(msg.value > 0, "You need to aport more than 0");
        author.transfer(msg.value);
        fundingRaised += msg.value;
        emit FundProject(id, msg.sender, msg.value);
    }

    function changeState(uint256 newState) public isAuthor {
        require(
            newState == 0 || newState == 1,
            "The project is not defined, only acept 0 and 1"
        );
        require(newState != state, "The state is declared with the same state");
        if (newState == 0) {
            state = newState;
            stateIs = "Open";
            emit ChangeState(id, msg.sender, stateIs, state);
        } else if (newState == 1) {
            state = newState;
            stateIs = "Closed";
            emit ChangeState(id, msg.sender, stateIs, state);
        }
    }
}
