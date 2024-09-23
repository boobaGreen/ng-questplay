// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract DynamicArray {

     /// @notice Copies `array` into a new memory array 
    /// and pushes `value` into the new array.
    /// @return array_ The new array with the added value.
    function push(
        uint256[] memory array, 
        uint256 value
    ) public pure returns (uint256[] memory array_) {
        assembly {
            // Get the length of the old array
            let length := mload(array)
            // Calculate the new size (old length + 1)
            let newSize := add(length, 1)
            // Get the current free memory pointer
            array_ := mload(0x40)
            // Set the new array's length
            mstore(array_, newSize)
            // Update the free memory pointer to after the new array's space
            let newMemoryLocation := add(array_, add(0x20, mul(newSize, 0x20)))
            mstore(0x40, newMemoryLocation)
            
            // Copy elements from the old array into the new array
            for {
                let i := 0
            } lt(i, length) {
                i := add(i, 1)
            } {
                let element := mload(add(add(array, 0x20), mul(i, 0x20)))
                mstore(add(add(array_, 0x20), mul(i, 0x20)), element)
            }
            
            // Store the new value at the end of the new array
            mstore(add(add(array_, 0x20), mul(length, 0x20)), value)
        }
    }

   /// @notice Pops the last element from a memory array.
    /// @dev Reverts if array is empty.
    /// @return array_ The original array with the length reduced by 1.
    function pop(uint256[] memory array) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {
            // Get the length of the array
            let length := mload(array)
            
            // Revert if the array is empty
            if iszero(length) {
                revert(0, 0)
            }

            // Reduce the array length by 1 (in-place modification)
            mstore(array, sub(length, 1))

            // Return the modified array
            array_ := array
        }
    }

     /// @notice Pops the `index`th element from a memory array.
    /// @dev Reverts if index is out of bounds.
    /// @return array_ The original array with the `index`th element removed.
    function popAt(uint256[] memory array, uint256 index) 
        public 
        pure 
        returns (uint256[] memory array_) 
    {
        assembly {
            // Get the length of the array
            let length := mload(array)

            // Revert if the index is out of bounds
            if iszero(lt(index, length)) {
                revert(0, 0)
            }

            // Calculate the new length (length - 1)
            let newSize := sub(length, 1)

            // Shift elements after the index to the left by one position
            for { 
                let i := index 
            } lt(i, newSize) {
                i := add(i, 1)
            } {
                let nextElement := mload(add(add(array, 0x20), mul(add(i, 1), 0x20)))
                mstore(add(add(array, 0x20), mul(i, 0x20)), nextElement)
            }

            // Update the length of the array (in-place)
            mstore(array, newSize)

            // Return the modified array
            array_ := array
        }
    }

}