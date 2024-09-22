// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract UltimateSuitV2 is Initializable, ERC721Upgradeable {
    event Detonate(uint256 bombId);

    enum Status {
        CONFIRMED_BY_A,
        CONFIRMED_BY_B,
        LAUNCHED,
        DETONATED
    }

    struct BombStats {
        address target; // Mantieni il nome per la compatibilità
        uint256 damage;
        Status status;
        uint8 transfersLeft; // Aggiungi alla fine
    }

    uint8 constant TRANSFERS = 3; // 2 transfers before detonation

    address private pilotA;
    address private pilotB;
    
    // Mantieni la variabile per la compatibilità
    uint256 public bombCount;

    mapping(uint256 => BombStats) private bombStats;

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

    modifier isUnconfirmed(uint256 _bombId, address _pilot) {
        require(_bombId < bombCount, "Bomb not initialized");

        Status expectedStatus = msg.sender == pilotA 
            ? Status.CONFIRMED_BY_B 
            : Status.CONFIRMED_BY_A;
        require(bombStats[_bombId].status == expectedStatus, "msg.sender already confirmed bomb");

        _;
    }

 

    function createBomb(address _initialTarget, uint256 _damage) public isPilot(msg.sender) returns (uint256 bombId) {
        bombId = bombCount;
        _mint(address(this), bombId);
        BombStats storage stats = bombStats[bombId];
        stats.target = _initialTarget; // Mantieni il nome
        stats.damage = _damage;
        stats.status = msg.sender == pilotA ? Status.CONFIRMED_BY_A : Status.CONFIRMED_BY_B;

        bombCount++;
    }

    function confirmBomb(uint256 bombId) public 
        isPilot(msg.sender) 
        isUnconfirmed(bombId, msg.sender)
    {
        bombStats[bombId].status = Status.LAUNCHED;
        bombStats[bombId].transfersLeft = TRANSFERS;
        _transfer(address(this), bombStats[bombId].target, bombId);
    }

    function getPilots() external view returns (address, address) {
        return (pilotA, pilotB);
    }
    
    function _transfer(address from, address to, uint256 bombId) internal override {
        require(bombStats[bombId].status != Status.DETONATED, "Bomb already detonated");

        bombStats[bombId].transfersLeft--;
        if (bombStats[bombId].transfersLeft == 0) {
            emit Detonate(bombId);
            bombStats[bombId].status = Status.DETONATED;
        }
        super._transfer(from, to, bombId);
    }
}
