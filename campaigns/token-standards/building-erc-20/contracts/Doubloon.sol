// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC20.sol";

/**
 * @dev Contratto token con funzioni getter per nome, simbolo e fornitura totale.
 */
contract Doubloon {
    string public constant name = "Doubloon";
    string public constant symbol = "DBL";

    uint256 public totalSupply; // Variabile di stato per la fornitura totale di token.

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    /**
     * @dev Evento emesso al trasferimento di token.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Evento emesso quando l'approvazione viene concessa a un account per spendere token.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    /**
     * @dev Il costruttore inizializza la fornitura totale dei token.
     * @param _supply La quantità iniziale di token da creare.
     */
    constructor(uint256 _supply) {
        totalSupply = _supply; // Imposta la fornitura totale (aggiunge i decimali).
        balanceOf[msg.sender] = totalSupply; // Assegna tutti i token al creatore iniziale.
    }

    /**
     * @dev Trasferisce token a un altro indirizzo.
     * @param _to Indirizzo del destinatario.
     * @param _value Quantità di token da trasferire.
     * @return Booleano che indica se il trasferimento è riuscito.
     */
    function transfer(address _to, uint256 _value) external returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Saldo insufficiente");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Approva un account a spendere una quantità specifica di token.
     * @param _spender Indirizzo del conto che può spendere i token.
     * @param _amount Quantità di token approvati.
     * @return Booleano che indica se l'approvazione è riuscita.
     */
    function approve(
        address _spender,
        uint256 _amount
    ) external returns (bool) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    /**
     * @dev Trasferisce token per conto di un altro account.
     * @param _from Indirizzo da cui trasferire.
     * @param _to Indirizzo del destinatario.
     * @param _amount Quantità di token da trasferire.
     * @return Booleano che indica se il trasferimento è riuscito.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external returns (bool) {
        require(balanceOf[_from] >= _amount, "Fondi insufficienti");
        require(
            allowance[_from][msg.sender] >= _amount,
            "Allowance insufficiente"
        );

        allowance[_from][msg.sender] -= _amount;
        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
    }
}
