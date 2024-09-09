// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC721TokenReceiver.sol";
import "./interfaces/IAmuletPouch.sol";

/**
 * @dev AmuletPouch contract that implements a multisig-like approval system for withdrawing NFTs.
 */
contract AmuletPouch is IAmuletPouch, IERC721TokenReceiver {
    address public immutable amuletAddress;

    struct WithdrawRequest {
        address requester;
        uint256 tokenId;
        uint256 votes;
        bool processed;
    }

    mapping(address => bool) public isMember;
    address[] public members;
    mapping(uint256 => WithdrawRequest) public withdrawRequests;
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    uint256 public totalRequests;
    uint256 public totalMembers;

    event WithdrawRequested(
        address indexed requester,
        uint256 indexed tokenId,
        uint256 indexed requestId
    );
    event WithdrawCompleted(address indexed requester, uint256 indexed tokenId);

    constructor(address _amulet) {
        amuletAddress = _amulet;
    }

    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data
    ) external override returns (bytes4) {
        require(msg.sender == amuletAddress, "Invalid token");

        if (!isMember[_from]) {
            isMember[_from] = true;
            members.push(_from);
            totalMembers++;
        }

        if (_data.length > 0) {
            uint256 requestedTokenId = abi.decode(_data, (uint256));
            require(
                IERC721(amuletAddress).ownerOf(requestedTokenId) ==
                    address(this),
                "Token not in pouch"
            );

            uint256 requestId = totalRequests++;
            withdrawRequests[requestId] = WithdrawRequest({
                requester: _from,
                tokenId: requestedTokenId,
                votes: 1,
                processed: false
            });

            hasVoted[requestId][_from] = true;

            emit WithdrawRequested(_from, requestedTokenId, requestId);
        }

        return IERC721TokenReceiver.onERC721Received.selector;
    }

    function voteFor(uint256 _requestId) external {
        require(isMember[msg.sender], "Not a member");
        require(!hasVoted[_requestId][msg.sender], "Already voted");
        require(_requestId < totalRequests, "Invalid request");

        WithdrawRequest storage request = withdrawRequests[_requestId];
        require(!request.processed, "Request already processed");

        hasVoted[_requestId][msg.sender] = true;
        request.votes++;

        if (request.votes > totalMembers / 2) {
            request.processed = true;
            _withdraw(request.requester, request.tokenId);
        }
    }

    function withdraw(uint256 _requestId) external {
        WithdrawRequest storage request = withdrawRequests[_requestId];
        require(request.requester == msg.sender, "Not the requester");
        require(request.votes > totalMembers / 2, "Not enough votes");
        require(!request.processed, "Already processed");

        request.processed = true;
        _withdraw(msg.sender, request.tokenId);
    }

    function _withdraw(address _to, uint256 _tokenId) internal {
        IERC721(amuletAddress).safeTransferFrom(address(this), _to, _tokenId);
        emit WithdrawCompleted(_to, _tokenId);
    }

    function isMember(address _user) external view returns (bool) {
        return isMember[_user];
    }

    function withdrawRequest(
        uint256 _requestId
    ) external view returns (address, uint256) {
        WithdrawRequest storage request = withdrawRequests[_requestId];
        return (request.requester, request.tokenId);
    }

    function numVotes(uint256 _requestId) external view returns (uint256) {
        return withdrawRequests[_requestId].votes;
    }

    function totalMembers() external view returns (uint256) {
        return totalMembers;
    }
}
