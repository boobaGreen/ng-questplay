// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    /**
     * @dev Converts an integer to roman numerals
     * @param n Integer to convert to roman numerals (0 <= n <= 3999)
     * @return String of roman numerals
     */
    function romanify(uint256 n) external pure returns (string memory) {
        require(n <= 3999, "Number must be less than or equal to 3999");

        // Define symbols and corresponding values
        string[13] memory romanNumerals = [
            "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"
        ];
        uint16[13] memory values = [
            1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
        ];

        // Create the result array with an upper bound for length
        bytes memory result = new bytes(15); // Maximum length for 3999
        uint256 index = 0;

        for (uint8 i = 0; i < romanNumerals.length; i++) {
            while (n >= values[i]) {
                bytes memory numeral = bytes(romanNumerals[i]);
                for (uint256 j = 0; j < numeral.length; j++) {
                    result[index++] = numeral[j];
                }
                n -= values[i];
            }
        }

        // Resize the result to the actual length
        bytes memory finalResult = new bytes(index);
        for (uint256 i = 0; i < index; i++) {
            finalResult[i] = result[i];
        }

        return string(finalResult);
    }
}
