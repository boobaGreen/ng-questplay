// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MechSuitV2 {

 

    uint32 public fuel;
    uint8 public ammunition;

    function blastCannon() external returns (bytes32) {
        ammunition -= 1;
        return keccak256("BOOM!");
    }

    function refuel() external payable {
        require(msg.value == 1 gwei);
        fuel = 100;
        ammunition = 8;
    }


}