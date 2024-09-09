// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @dev Contratto token con funzioni getter per nome, simbolo e fornitura totale.
 */
contract Doubloon {
    uint256 private _totalSupply; // Variabile di stato per la fornitura totale di token.

    /**
     * @dev Il costruttore inizializza la fornitura totale dei token.
     * @param _supply La quantità iniziale di token da creare.
     */
    constructor(uint256 _supply) {
        _totalSupply = _supply; // Imposta la fornitura totale.
    }

    /**
     * @dev Ritorna il nome del token.
     */
    function name() public pure returns (string memory) {
        return "Doubloon"; // Restituisce il nome del token.
    }

    /**
     * @dev Ritorna il simbolo del token.
     */
    function symbol() public pure returns (string memory) {
        return "DBL"; // Restituisce il simbolo del token.
    }

    /**
     * @dev Ritorna la fornitura totale di token.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply; // Restituisce la fornitura totale.
    }
}
