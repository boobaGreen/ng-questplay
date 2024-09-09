// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC721Metadata.sol";
import "./interfaces/IERC721TokenReceiver.sol";

/**
 * @dev ERC-721 token contract.
 */
contract Amulet /* is IERC721, IERC721Metadata */ {
    string public constant name = "Amulet";
    string public constant symbol = "AMULET";

    address private immutable creator;
    mapping(uint => string) private uris;
    uint256 private nextId;
    
    constructor() {
        creator = msg.sender;
    }

    function tokenURI(uint256 _tokenId) external view returns (string memory) {
        require(_tokenId < nextId, "Invalid token");
        return uris[_tokenId];
    }
}
