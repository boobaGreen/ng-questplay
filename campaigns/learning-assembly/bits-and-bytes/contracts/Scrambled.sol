// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Scrambled {

    /// @notice Recover an address that has been scrambled into a 256-bit value
    function recoverAddress(bytes32 scrambledValue)
        public
        pure
        returns (address rvalue)
    {
        assembly {
            // Mask to isolate the last 7 bytes (56 bits)
            let mask_a := 0x0000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFF // Mask to keep last 7 bytes
            
            // Apply the mask to get the last 7 bytes
            let pre_a := and(scrambledValue, mask_a)
            
            // Shift right by 1 byte (8 bits) to align part_a to the rightmost position
            let part_a := shr(8, pre_a)

            // Mask and shift to get part_b
            let shift_amount_b := 88 // Number of bits to shift to align part_b to the rightmost position
            let mask_b := 0x0000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF // Mask to keep last 6 bytes
            let shiftedValue_b := shr(shift_amount_b, scrambledValue)
            let part_b := and(shiftedValue_b, mask_b)

            // Mask and shift to get part_c
            let shift_amount_c := 200 // Number of bits to shift to align part_c to the rightmost position
            let mask_c := 0x0000000000000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFF // Mask to keep last 6 bytes
            let shiftedValue_c := shr(shift_amount_c, scrambledValue)
            let part_c := and(shiftedValue_c, mask_c)

            // Construct the final 20-byte address
        
            let semiResult := or(part_c, shl(48, part_b))
            rvalue := or(semiResult, shl(96, part_a))
        }
    }
}
