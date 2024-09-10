// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC721.sol";
import "./interfaces/IAmuletPouch.sol";

/**
 * @dev ERC-721 Token Receiver token contract.
 */
/* is IAmuletPouch */ contract AmuletPouch {
    address private immutable amuletContract;
    mapping(address => bool) private members;
    mapping(uint256 => Request) private requests;
    uint256 private memberCount;
    mapping(uint256 => mapping(address => bool)) private votes;
    uint256 private nextRequestId;

    struct Request {
        address requester;
        uint256 tokenId;
        uint256 votes;
    }

    constructor(address _amulet) {
        amuletContract = _amulet;
    }

    event WithdrawRequested(
        address indexed requester,
        uint256 indexed tokenId,
        uint256 indexed requestId
    );

    function isMember(address _user) external view returns (bool) {
        return members[_user];
    }

    function onERC721Received(
        address /* _operator */,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external returns (bytes4) {
        require(msg.sender == amuletContract, "Only Amulet can be accepted");

        if (!members[_from]) {
            members[_from] = true;
            memberCount++;
        } else if (_data.length > 0) {
            uint256 requestId = uint256(bytes32(_data));
            requests[nextRequestId++] = Request(_from, _tokenId, 1);
            emit WithdrawRequested(_from, _tokenId, requestId);
        }

        return this.onERC721Received.selector;
    }

    function withdrawRequest(
        uint256 _requestId
    ) external view returns (address, uint256) {
        Request storage request = requests[_requestId];
        return (request.requester, request.tokenId);
    }

    function numVotes(uint256 _requestId) external view returns (uint256) {
        return requests[_requestId].votes;
    }

    function totalMembers() external view returns (uint256) {
        return memberCount;
    }

    function voteFor(uint256 _requestId) external {
        require(members[msg.sender], "Not a member");
        require(!votes[_requestId][msg.sender], "Already voted");
        require(
            requests[_requestId].requester != address(0),
            "Request does not exist"
        );

        votes[_requestId][msg.sender] = true;
        requests[_requestId].votes++;
    }

    function withdraw(uint256 _requestId) external {
        Request storage request = requests[_requestId];
        require(request.votes + 1 > memberCount / 2, "Not enough votes");
        require(request.requester == msg.sender, "Not the requester");

        IERC721(amuletContract).transferFrom(
            address(this),
            msg.sender,
            request.tokenId
        );

        delete requests[_requestId];
    }
}
