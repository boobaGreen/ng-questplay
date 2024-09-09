// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./Doubloon.sol";

/**
 * @dev Contratto che eredita da Doubloon e aggiunge funzionalità di minting.
 */
contract MintableDoubloon is Doubloon {
    address public owner;

    /**
     * @dev Costruttore che imposta il creatore del contratto come proprietario.
     * @param _supply La quantità iniziale di token da creare.
     */
    constructor(uint256 _supply) Doubloon(_supply) {
        owner = msg.sender; // Imposta il creatore del contratto come proprietario.
    }

    /**
     * @dev Funzione per creare nuovi token.
     * Può essere chiamata solo dal proprietario del contratto.
     * @param _to Indirizzo a cui verranno assegnati i nuovi token.
     * @param _amount Quantità di token da creare.
     */
    function mint(address _to, uint256 _amount) external {
        require(
            msg.sender == owner,
            "Solo il proprietario può mintare nuovi token"
        );

        uint256 mintAmount = _amount * (10 ** uint256(decimals)); // Aggiunge i decimali all'importo da mintare
        totalSupply += mintAmount; // Aumenta la fornitura totale con i decimali inclusi
        balanceOf[_to] += mintAmount; // Aggiunge i nuovi token al bilancio dell'indirizzo _to
        emit Transfer(address(0), _to, mintAmount); // Emissione evento Transfer con from impostato a zero address
    }
}
