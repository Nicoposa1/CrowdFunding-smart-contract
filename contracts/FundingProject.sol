//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

contract fundingProject {
    enum FundraisingState {
        Opened,
        Closed
    }

    struct Contribution {
        address contributor;
        uint256 amount;
    }

    struct Project {
        string id;
        string name;
        string description;
        uint256 fundingGoal;
        address payable author;
        FundraisingState state;
        string stateIs;
        uint256 fundingRaised;
    }

    Project[] public projects;
    mapping(string => Contribution[]) public contributions;

    event CreateProject(
        string id,
        string name,
        string description,
        uint256 fundingGoal
    );

    event FundProject(string id, address sender, uint256 amount);

    event ChangeState(
        string id,
        address changer,
        FundraisingState state,
        string stateIs
    );

    modifier isAuthor(uint256 projectIndex) {
        require(
            projects[projectIndex].author == msg.sender,
            "Only the author can change the state"
        );
        _;
    }

    modifier isNotAuthor(uint256 projectIndex) {
        require(
            projects[projectIndex].author != msg.sender,
            "As author you can't fund your own project"
        );
        _;
    }

    function createProject(
        string calldata id,
        string calldata name,
        string calldata description,
        uint256 fundingGoal
    ) public {
        require(fundingGoal > 0, "The Goal must be greater than 0");
        Project memory project = Project(
            id,
            name,
            description,
            fundingGoal,
            payable(msg.sender),
            FundraisingState.Opened,
            "Open",
            0
        );
        projects.push(project);
        emit CreateProject(
            project.id,
            project.name,
            project.description,
            project.fundingGoal
        );
    }

    function fundProject(uint256 projectIndex)
        public
        payable
        isNotAuthor(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(msg.value > 0, "Fund value must be greater than 0");
        require(
            project.state == FundraisingState.Opened,
            "The project is closed"
        );

        project.author.transfer(msg.value);
        project.fundingGoal += msg.value;
        projects[projectIndex] = project;
        emit FundProject(project.id, msg.sender, msg.value);
    }

    function changeState(FundraisingState newState, uint256 projectIndex)
        public
        isAuthor(projectIndex)
    {
        Project memory project = projects[projectIndex];
        require(
            newState != project.state,
            "The state is defined with the same state"
        );

        if (newState == FundraisingState.Opened) {
            project.state = newState;
            project.stateIs = "Open";
            projects[projectIndex] = project;
            emit ChangeState(
                project.id,
                msg.sender,
                project.state,
                project.stateIs
            );
        } else if (newState == FundraisingState.Closed) {
            project.state = newState;
            project.stateIs = "Closed";
            projects[projectIndex] = project;
        }
    }
}
