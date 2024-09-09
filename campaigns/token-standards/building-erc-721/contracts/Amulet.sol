// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC721Metadata.sol";
import "./interfaces/IERC721TokenReceiver.sol";

/**
 * @dev ERC-721 token contract.
 */
/* is IERC721, IERC721Metadata */ contract Amulet {
    string public constant name = "Amulet";
    string public constant symbol = "AMULET";

    address private immutable creator;
    mapping(uint => string) private uris;
    uint256 private nextId;

    mapping(address => uint) balance;
    mapping(uint => address) owner;

    constructor() {
        creator = msg.sender;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_tokenId < nextId, "Invalid token");
        return uris[_tokenId];
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(_owner != address(0), "Invalid address!");
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        require(_tokenId < nextId, "Invalid token!");
        return owner[_tokenId];
    }

    function mint(
        address _owner,
        string calldata _uri
    ) external returns (uint256) {
        require(msg.sender == creator, "Only creator can mint!");
        owner[nextId] = _owner;
        balance[_owner]++;
        uris[nextId] = _uri;

        return nextId++;
    }
    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return (interfaceId == type(IERC165).interfaceId ||
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId);
    }
}
