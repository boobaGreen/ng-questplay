// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MaskGenerator {
    
    /// @notice Generates a mask.
    /// @param nBytes Width of mask in bytes.
    /// @param at Start of bytemask (little endian index)
    /// @param reversed If true, bytemask is a mask of 0s. Otherwise, bytemask is a regular mask of 1s.
    /// @dev Should revert if (`nBytes` + `at` > 32)
    function generateMask(
        uint256 nBytes,
        uint256 at,
        bool reversed
    ) public pure returns (uint256 mask) {
        assembly {
            // Revert if nBytes + at > 32 (256 bits)
            if gt(add(nBytes, at), 32) {
                revert(0, 0)
            }

            // Calculate the mask of nBytes width filled with 1's
            let onesMask := sub(shl(mul(nBytes, 8), 1), 1)

            // Shift the mask to the correct position (at bytes from the right)
            onesMask := shl(mul(at, 8), onesMask)

            // If reversed is true, invert the mask to make 1's into 0's and vice versa
            switch reversed
            case 0 {
                // If reversed is false, use the mask as it is
                mask := onesMask
            }
            default {
                // If reversed is true, invert the mask (bitwise negation)
                mask := not(onesMask)
            }
        }
    }
}
