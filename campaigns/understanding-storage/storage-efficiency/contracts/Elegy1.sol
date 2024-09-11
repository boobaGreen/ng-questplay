// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Elegy1 {
    // slot da 256 bits o 32 bytes

    // ORIGINALS

    // bytes8 public firstVerse; // 8 bytes o 64 bits
    // bytes32 public secondVerse; //32 bytes o 256 bits
    // address public thirdVerse; // 20 bytes o 160 bits
    // uint128 public fourthVerse; // 16 bytes o 128 bits
    // uint96 public fifthVerse; // 12 bytes o 96 bits

    // SOLUTIONS
    
    bytes32 public secondVerse; // 32 bytes
    address public thirdVerse; // 20 bytes
    uint96 public fifthVerse; // 12 bytes
    uint128 public fourthVerse; // 16 bytes
    bytes8 public firstVerse; // 8 bytes

    function setVerse(
        bytes8 _firstVerse,
        bytes32 _secondVerse,
        address _thirdVerse,
        uint128 _fourthVerse,
        uint96 _fifthVerse
    ) external {
        firstVerse = _firstVerse;
        secondVerse = _secondVerse;
        thirdVerse = _thirdVerse;
        fourthVerse = _fourthVerse;
        fifthVerse = _fifthVerse;
    }
}
