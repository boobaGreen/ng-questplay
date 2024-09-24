// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract MemoryLayout {

    /// @notice Create an uint256 memory array.
    /// @param size The size of the array.
    /// @param value The initial value of each element of the array.
    function createUintArray(
        uint256 size, 
        uint256 value
    ) public pure returns (uint256[] memory array) {
        assembly {
            // 1. Read start of free memory
            array := mload(0x40)

            // 2. Record the length of the array
            mstore(array, size)

            // 3. Initialize next `size` words with `value`.
            let offset := 0x20 // Starting offset (skipping the length field)

            // Initialize the content of the array to the given value
            for {let i := 0} lt(i, size) {i := add(i, 0x01)} {
                mstore(add(array, offset), value)
                offset := add(offset, 0x20)
            }

            // 4. Mark the array memory area as allocated
            mstore(0x40, add(array, offset))
        }
    }

    /// @notice Create a bytes memory array.
    /// @param size The size of the array.
    /// @param value The initial value of each element of the array.
    function createBytesArray(
        uint256 size, 
        bytes1 value
    ) public pure returns (bytes memory array) {
        assembly {
            // 1. Read start of free memory
            array := mload(0x40)

            // 2. Record the length of the array (in bytes, not words)
            mstore(array, size)

            // 3. Initialize next `size` bytes with `value`.
            let offset := 0x20 // Starting offset (skipping the length field)

            // Initialize the content of the array to the given value
            for {let i := 0} lt(i, size) {i := add(i, 1)} {
                // Shift the left-aligned `bytes1` value to the right
                mstore8(add(array, offset), byte(0, value)) // Extract rightmost byte
                offset := add(offset, 1)
            }

            // 4. Mark the array memory area as allocated
            mstore(0x40, add(array, add(0x20, size)))
        }
    }
}
