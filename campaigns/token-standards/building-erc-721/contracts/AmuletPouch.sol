// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "hardhat/console.sol";
import "./interfaces/IAmuletPouch.sol";
import "./Amulet.sol";

contract AmuletPouch is IAmuletPouch {
    Amulet public immutable amulet;
    address[] public members;
    uint256 private nextRequestId;

    struct WithdrawRequest {
        address requester;
        uint256 tokenId;
        uint256 votes;
        bool completed;
    }

    mapping(address => bool) public isMemberMap;
    mapping(uint256 => WithdrawRequest) public withdrawRequests;
    mapping(address => mapping(uint256 => bool)) public hasVoted;

    constructor(address _amulet) {
        amulet = Amulet(_amulet);
    }

    // Return whether the user is a member of the pouch
    function isMember(address _user) external view override returns (bool) {
        return isMemberMap[_user];
    }

    // Return the total number of members
    function totalMembers() external view override returns (uint256) {
        return members.length;
    }

    // Return details of a specific withdraw request
    function withdrawRequest(
        uint256 _requestId
    ) external view override returns (address, uint256) {
        WithdrawRequest memory request = withdrawRequests[_requestId];
        return (request.requester, request.tokenId);
    }

    // Return the number of votes for a specific request
    function numVotes(
        uint256 _requestId
    ) external view override returns (uint256) {
        return withdrawRequests[_requestId].votes;
    }

    // Vote for a withdraw request
    function voteFor(uint256 _requestId) external override {
        require(isMemberMap[msg.sender], "Not a member");
        require(!hasVoted[msg.sender][_requestId], "Already voted");
        require(_requestId < nextRequestId, "Request does not exist");

        WithdrawRequest storage request = withdrawRequests[_requestId];
        request.votes++;
        hasVoted[msg.sender][_requestId] = true;
    }

    // Withdraw the amulet if majority vote is reached
    function withdraw(uint256 _requestId) external override {
        WithdrawRequest storage request = withdrawRequests[_requestId];

        require(request.requester == msg.sender, "Not the requester");
        require(request.votes > members.length / 2, "Insufficient votes");
        require(!request.completed, "Request already processed");

        request.completed = true;
        amulet.safeTransferFrom(address(this), msg.sender, request.tokenId);
    }

    // Handle ERC721 token reception and register members or withdrawal requests
    function onERC721Received(
        address,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external override returns (bytes4) {
        require(msg.sender == address(amulet), "Only Amulets allowed");
        require(_tokenId >= 0, "Invalid token");

        if (!isMemberMap[_from]) {
            members.push(_from);
            isMemberMap[_from] = true;
        } else if (_data.length > 0) {
            uint256 withdrawTokenId = abi.decode(_data, (uint256));
            withdrawRequests[nextRequestId] = WithdrawRequest({
                requester: _from,
                tokenId: withdrawTokenId,
                votes: 1,
                completed: false
            });
            emit WithdrawRequested(_from, withdrawTokenId, nextRequestId);
            hasVoted[_from][nextRequestId] = true;
            nextRequestId++;
        }

        return this.onERC721Received.selector;
    }
}
