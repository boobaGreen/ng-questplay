// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Contratto token con funzioni getter per nome, simbolo e fornitura totale.
 */
contract Doubloon {
    string public constant name = "Doubloon";
    string public constant symbol = "DBL";
    uint256 public totalSupply; // Variabile di stato per la fornitura totale di token.

    /**
     * @dev Il costruttore inizializza la fornitura totale dei token.
     * @param _supply La quantità iniziale di token da creare.
     */
    constructor(uint256 _supply) {
        totalSupply = _supply; // Imposta la fornitura totale.
    }
}
