// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    /**
     * @dev Remove duplicates from an array of uint8
     * @param input An array of uint8
     * @return output An array of uint8 without duplicates
     */
    function dispelDuplicates(
        uint8[] calldata input
    ) public pure returns (uint8[] memory output) {
        uint8[] memory temp = new uint8[](input.length);
        bool[256] memory seen; // Vettore per tenere traccia dei valori già visti
        uint8 uniqueIndex = 0;

        for (uint8 i = 0; i < input.length; i++) {
            if (!seen[input[i]]) {
                seen[input[i]] = true; // Marca il numero come visto
                temp[uniqueIndex] = input[i];
                uniqueIndex++;
            }
        }

        // Crea l'array finale della dimensione corretta
        output = new uint8[](uniqueIndex);
        for (uint8 i = 0; i < uniqueIndex; i++) {
            output[i] = temp[i];
        }
    }
}
