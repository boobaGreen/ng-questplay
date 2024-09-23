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
        // 1. Read start of free memory
        array := mload(0x40)

        // 2. Record the length of the array (in bytes, not words)
        mstore(array, size)

        // 3. Calculate the initial offset (0x20 bytes for the length field)
        let offset := add(array, 0x20)

        // 4. Prepare the value for left alignment (shift left by 248 bits)
        let alignedValue := shl(248, value)

        // 5. Loop to initialize the array's content with `value`
        for { let i := 0 } lt(i, size) { i := add(i, 1) } {
            mstore8(add(offset, i), alignedValue)  // Store the aligned value byte by byte
        }

        // 6. Update free memory pointer to the end of the array
        // Array length (0x20) + data size (size)
        mstore(0x40, add(add(array, 0x20), size))
    }
}

}
