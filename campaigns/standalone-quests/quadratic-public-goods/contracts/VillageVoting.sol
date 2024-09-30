// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IVillageVoting.sol";

contract VillageVoting is IVillageVoting {

    struct Proposal {
        uint256 id;
        uint256 votePower;  // total vote power for the proposal
    }

    mapping(address => uint256) private balances;  // Villager token balances
    mapping(address => bool) private hasVoted;  // Track if a villager has voted
    Proposal[] private proposals;  // Array of proposals
    uint256 public votingEnd;  // Voting end timestamp
    uint256 private winningProposalId;  // ID of the winning proposal
    bool private isWinnerDecided = false;  // Check if winner is decided

    event Voted(address indexed villager, uint256[] proposalIds, uint256[] amounts);

    constructor(
        address[] memory _villagers,
        uint256[] memory _tokenBalances,
        uint256[] memory _proposalIds
    ) {
        require(_villagers.length == _tokenBalances.length, "Invalid input lengths");
        
        // Initialize villager balances
        for (uint256 i = 0; i < _villagers.length; i++) {
            balances[_villagers[i]] = _tokenBalances[i];
        }

        // Initialize proposals
        for (uint256 i = 0; i < _proposalIds.length; i++) {
            proposals.push(Proposal({
                id: _proposalIds[i],
                votePower: 0
            }));
        }

        // Set voting round end time (7 days from now)
        votingEnd = block.timestamp + 7 days;
    }

    function vote(uint256[] calldata proposalIds, uint256[] calldata amounts) external override {
        require(block.timestamp < votingEnd, "Voting round has ended");
        require(!hasVoted[msg.sender], "Villager has already voted");
        require(proposalIds.length == amounts.length, "Mismatched input arrays");

        uint256 totalTokens = balances[msg.sender];
        uint256 usedTokens = 0;

        // Check for duplicate proposal IDs
        for (uint256 i = 0; i < proposalIds.length; i++) {
            for (uint256 j = i + 1; j < proposalIds.length; j++) {
                require(proposalIds[i] != proposalIds[j], "Duplicate proposals");
            }
        }

        // Validate proposals and ensure valid token amounts
        for (uint256 i = 0; i < proposalIds.length; i++) {
            bool proposalExists = false;
            for (uint256 j = 0; j < proposals.length; j++) {
                if (proposals[j].id == proposalIds[i]) {
                    proposalExists = true;
                    uint256 sqrtAmount = sqrt(amounts[i]);
                    proposals[j].votePower += sqrtAmount;
                    usedTokens += amounts[i];
                    break;
                }
            }
            require(proposalExists, "Invalid proposal ID");
        }

        require(usedTokens <= totalTokens, "Insufficient tokens");

        // Mark villager as having voted
        hasVoted[msg.sender] = true;

        emit Voted(msg.sender, proposalIds, amounts);
    }

    function countVotes() external override {
        require(block.timestamp >= votingEnd, "Voting round is still ongoing");
        require(!isWinnerDecided, "Winner has already been decided");

        uint256 highestVotePower = 0;

        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].votePower > highestVotePower) {
                highestVotePower = proposals[i].votePower;
                winningProposalId = proposals[i].id;
            } else if (proposals[i].votePower == highestVotePower && proposals[i].id < winningProposalId) {
                winningProposalId = proposals[i].id;
            }
        }

        isWinnerDecided = true;
    }

    // View functions

    function getProposals() external view override returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](proposals.length);
        for (uint256 i = 0; i < proposals.length; i++) {
            ids[i] = proposals[i].id;
        }
        return ids;
    }

    function getWinningProposal() external view override returns (uint256) {
        require(isWinnerDecided, "Winner has not been decided yet");
        return winningProposalId;
    }

    function balanceOf(address villager) external view override returns (uint256) {
        return balances[villager];
    }

    function votePower(uint256 proposalId) external view override returns (uint256) {
        for (uint256 i = 0; i < proposals.length; i++) {
            if (proposals[i].id == proposalId) {
                return proposals[i].votePower;
            }
        }
        revert("Invalid proposal ID");
    }

    // Internal utility functions

    function sqrt(uint256 x) internal pure returns (uint256) {
        return uint256(sqrtHelper(int256(x)));
    }

    function sqrtHelper(int256 x) internal pure returns (int256 y) {
        int256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
