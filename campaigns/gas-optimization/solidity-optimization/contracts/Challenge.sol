// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Challenge {

    uint256 immutable _SKIP;

    constructor(uint256 skip) {
        _SKIP = skip;
    }

    /** 
     * @notice Returns the sum of the elements of the given array, skipping any SKIP value.
     * @param array The array to sum.
     * @return sum The sum of all the elements of the array excluding SKIP.
     */
    function sumAllExceptSkip(
        uint256[] calldata array
    ) public view returns (uint256 sum) {

        uint256 cacheSkip = _SKIP;  // Cache SKIP value in memory for cheaper access

        // Use unchecked block to optimize the increment of i
        for (uint256 i = 0; i < array.length; ) {
            uint256 element = array[i]; // Cache array value
            if (element != cacheSkip) {
                sum += element;
            }

            unchecked {
                ++i; // More gas efficient than i++
            }
        }

        return sum; 
    }

}
