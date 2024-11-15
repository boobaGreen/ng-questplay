// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";



contract UltimateSuitV1 is Initializable, ERC721Upgradeable {
    // DO NOT REMOVE
    enum Status {
        CONFIRMED_BY_A,
        CONFIRMED_BY_B,
        LAUNCHED
    }

    // DO NOT REMOVE
    struct BombStats {
        address target;
        uint256 damage;
        Status status;
    }

    address private pilotA;
    address private pilotB;

    uint256 public bombCount;
    mapping (uint => BombStats) private bombStats;

    modifier isPilot(address _address) {
        require(_address == pilotA || _address == pilotB, "Not a pilot");
        _; 
    }
    
    
   

    
    // Initializer function for setting up the contract
    function initialize(address _pilotA, address _pilotB) external initializer {
        __ERC721_init("Ultimate Suit", "SUIT");
        pilotA = _pilotA;
        pilotB = _pilotB;
    }


    function createBomb(
        address _target, 
        uint256 _damage
    ) public isPilot(msg.sender) returns (uint256 bombId) {
        _mint(address(this), bombCount);
        BombStats storage stats = bombStats[bombCount];
        stats.target = _target;
        stats.damage = _damage;
        stats.status = msg.sender == pilotA
            ? Status.CONFIRMED_BY_A
            : Status.CONFIRMED_BY_B;

        return bombCount++;
    }

    function confirmBomb(uint256 bombId) public isPilot(msg.sender) {
        require(bombId < bombCount, "Bomb not initialized");
        Status expectedStatus = msg.sender == pilotA 
            ? Status.CONFIRMED_BY_B 
            : Status.CONFIRMED_BY_A;
        require(bombStats[bombId].status == expectedStatus, "msg.sender already confirmed bomb");

        bombStats[bombId].status = Status.LAUNCHED;
        _transfer(
            address(this), 
            bombStats[bombId].target,
            bombId
        );
    }

    function getPilots() external view returns (address, address) {
        return (pilotA, pilotB);
    }

}