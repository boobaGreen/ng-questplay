// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract WhispersV2 {
    /// @notice Decodifica un array uint256 compresso
    /// @return array_ Un array decompressato di uint256
    function compressedWhisper() public pure returns (uint256[] memory array_) {
        assembly {
            // Calcola la dimensione del calldata, escludendo il selettore (4 byte)
            let totalSize := calldatasize()
            let dataSize := sub(totalSize, 4)

            // Alloca un'area di memoria per l'array dinamico
            array_ := mload(0x40)
            
            // Puntatore iniziale alla parte in cui salvare i dati dell'array
            let arrayPointer := add(array_, 0x20)

            // Variabile temporanea per tenere traccia di dove siamo nel calldata
            let offset := 4

            // Contatore del numero di elementi (lunghezza dell'array)
            let counter := 0

            // Continua a processare finché non hai letto tutto il calldata
            for { } lt(offset, totalSize) { } {
                // Leggi la lunghezza del prossimo valore (header, 1 byte)
                let length := byte(0, calldataload(offset))

                // Incrementa l'offset di 1 byte per leggere il valore
                offset := add(offset, 1)

                // Carica il valore compresso dal calldata
                let value := 0

                // Estrai i byte successivi corrispondenti alla lunghezza
                for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                    let shiftedByte := byte(0, calldataload(add(offset, i)))
                    value := or(shl(mul(sub(length, add(i, 1)), 8), shiftedByte), value)
                }

                // Incrementa l'offset della lunghezza letta
                offset := add(offset, length)

                // Memorizza il valore nell'array
                mstore(arrayPointer, value)

                // Aggiorna il puntatore dell'array e il contatore degli elementi
                arrayPointer := add(arrayPointer, 0x20)
                counter := add(counter, 1)
            }

            // Imposta la lunghezza dell'array
            mstore(array_, counter)

            // Aggiorna il puntatore della memoria libera
            mstore(0x40, arrayPointer)
        }
    }
}
