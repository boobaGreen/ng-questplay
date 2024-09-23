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
        
        // Starting offset is 0x20 (skipping the length field)
        let offset := 0x20

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
            // 1. Read the current free memory pointer
            array := mload(0x40)

            // 2. Store the length of the array
            mstore(array, size)

            // 3. The actual data starts at offset 0x20 after the length
            let dataStart := add(array, 0x20)

            // 4. Prepare the value for left alignment (shift left by 248 bits)
            let alignedValue := shl(248, value)

            // 5. Store each `bytes1` value, left-aligned in its word
            for { let i := 0 } lt(i, size) { i := add(i, 1) } {
                mstore(add(dataStart, mul(i, 0x20)), alignedValue)
            }

            // 6. Update the free memory pointer after storing all elements
            mstore(0x40, add(dataStart, mul(size, 0x20)))
        }
    }
}
