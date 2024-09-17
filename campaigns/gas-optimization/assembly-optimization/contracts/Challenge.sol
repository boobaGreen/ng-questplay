// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Challenge {

    /**
     * @notice Returns a copy of the given array in a gas efficient way.
     * @dev This contract will be called internally.
     * @param array The array to copy.
     * @return copy The copied array.
     */
    function copyArray(bytes memory array) 
        internal 
        pure 
        returns (bytes memory copy) 
    {
        assembly {
            // Get the length of the array
            let length := mload(array)
            // Allocate memory for the new array
            copy := mload(0x40)
            // Set the length of the new array
            mstore(copy, length)
            // Update the free memory pointer
            mstore(0x40, add(copy, add(32, length)))

            // Copy the contents of the array
            let src := add(array, 32) // Skip the length field
            let dest := add(copy, 32) // Skip the length field

            // Copy 32 bytes chunks
            let end := add(src, length)
            for { } lt(src, end) { src := add(src, 32) dest := add(dest, 32) } {
                mstore(dest, mload(src))
            }
        }
    }    
}
