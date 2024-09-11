// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Elegy2 {
    // ORIGINAL

    //uint32[] public lines;
    //uint public totalSum;

    uint32[] public lines; // 32 bytes o 256 bits per [0] dove ce la lunghezza
    uint public totalSum; //32 bytes o 256 bits

    constructor(uint32[] memory _lines) {
        lines = _lines;
    }

    // function play(uint nonce) external {
    //     totalSum = 0;
    //     for (uint i = 0; i < lines.length; i++) {
    //         totalSum += (i * nonce) * lines[i];
    //     }
    // }

    // SOLUTION

    function play(uint nonce) external {
        uint _totalSum = 0; // Variabile locale per evitare di accedere spesso a totalSum nello storage
        uint _length = lines.length; // Caching della lunghezza dell'array in memoria

        for (uint i = 0; i < _length; i++) {
            _totalSum += i * nonce * lines[i]; // Riduzione delle operazioni
        }

        totalSum = _totalSum; // Aggiornamento della variabile di stato una sola volta alla fine
    }
}
