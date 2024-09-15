// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract For {

    /// @notice Computes the sum of the range [beg, end), skipping multiples of 5 and stopping at any factor of end.
    function sumElements(uint256 beg, uint256 end) public pure returns (uint256 sum) {
        assembly {
            // Initialize sum to 0
            sum := 0

            // Loop through the numbers from beg to end - 1
            for { let i := beg } lt(i, end) { i := add(i, 1) } {
                
                // Skip multiples of 5
                if iszero(mod(i, 5)) { continue }

                // Stop the loop if i is a factor of end
                if iszero(mod(end, i)) { break }

                // Add i to the sum
                sum := add(sum, i)
            }
        }
    }
}
