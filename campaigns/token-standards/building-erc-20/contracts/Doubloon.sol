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
     * @dev Il costruttore inizializza la fornitura totale dei token.
     * @param _supply La quantità iniziale di token da creare.
     */
    constructor(uint256 _supply) {
        totalSupply = _supply; // Imposta la fornitura totale.
        balanceOf[msg.sender] = _supply; // Assegna tutti i token al creatore iniziale.
    }

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(balanceOf[msg.sender] >= _value, "Saldo insufficiente");
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(from, to, amount);
        return true;
    }

    function approve(
        address _spender,
        uint256 _amount
    ) external returns (bool) {
        allowance[msg.sender][_spender] = _amount;
        return true;
    }
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external returns (bool) {
        require(balanceOf[_from] >= _amount, "Insufficient funds");

        require(
            allowance[_from][msg.sender] >= _amount,
            "Insufficient allowance"
        );

        allowance[_from][msg.sender] -= _amount;

        balanceOf[_from] -= _amount;
        balanceOf[_to] += _amount;
        emit Approval(owner, spender, amount)
        return true;
    }
}
