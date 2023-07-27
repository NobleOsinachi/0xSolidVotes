// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolidVotes {
    address public owner;
    uint256 public totalPolls;

    struct Poll {
        uint256 pollId;
        string question;
        string[] options;
        mapping(uint256 => uint256) votesCount;
        bool isActive;
    }

    mapping(uint256 => Poll) public polls;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
        totalPolls = 0;
    }

    function createPoll(string memory question, string[] memory options) external onlyOwner {
        require(options.length > 1, "Poll must have at least two options");
        totalPolls++;
        polls[totalPolls] = Poll(totalPolls, question, options, true);
    }

    function vote(uint256 pollId, uint256 optionIndex) external {
        require(pollId <= totalPolls && pollId > 0, "Invalid poll ID");
        require(polls[pollId].isActive, "Poll is not active");
        require(optionIndex < polls[pollId].options.length, "Invalid option index");

        polls[pollId].votesCount[optionIndex]++;
    }

    function closePoll(uint256 pollId) external onlyOwner {
        require(pollId <= totalPolls && pollId > 0, "Invalid poll ID");
        polls[pollId].isActive = false;
    }

    function getPollResults(uint256 pollId) external view returns (uint256[] memory) {
        require(pollId <= totalPolls && pollId > 0, "Invalid poll ID");

        uint256[] memory results = new uint256[](polls[pollId].options.length);
        for (uint256 i = 0; i < polls[pollId].options.length; i++) {
            results[i] = polls[pollId].votesCount[i];
        }

        return results;
    }
}
