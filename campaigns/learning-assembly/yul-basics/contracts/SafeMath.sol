// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SafeMath {

    /// @notice Returns lhs + rhs.
    /// @dev Reverts on overflow / underflow.
    function add(
        int256 lhs, 
        int256 rhs
    ) public pure returns (int256 result) {
        assembly {
            // Perform the addition
            result := add(lhs, rhs)

            // Check for overflow
            let lhsIsNegative := slt(lhs, 0)
            let rhsIsNegative := slt(rhs, 0)
            let resultIsNegative := slt(result, 0)

            // Overflow conditions
            let overflowPositive := and(
                iszero(lhsIsNegative),
                iszero(rhsIsNegative)
            )

            let overflowNegative := and(
                lhsIsNegative,
                rhsIsNegative
            )

            let overflow := or(
                and(overflowPositive, resultIsNegative),
                and(overflowNegative, iszero(resultIsNegative))
            )

            if overflow {
                revert(0, 0)
            }
        }
    }

    /// @notice Returns lhs - rhs.
    /// @dev Reverts on overflow / underflow.
    function sub(int256 lhs, int256 rhs) public pure returns (int256 result) {
        assembly {
            // Perform the subtraction
            result := sub(lhs, rhs)
            
            // Check for underflow
            let lhsIsNegative := slt(lhs, 0)
            let rhsIsNegative := slt(rhs, 0)
            let resultIsNegative := slt(result, 0)

            // Underflow conditions
            let underflowPositive := and(
                iszero(lhsIsNegative),
                rhsIsNegative
            )

            let underflowNegative := and(
                lhsIsNegative,
                iszero(rhsIsNegative)
            )

            let underflow := or(
                and(underflowPositive, resultIsNegative),
                and(underflowNegative, iszero(resultIsNegative))
            )

            if underflow {
                revert(0, 0)
            }
        }
    }

    /// @notice Returns lhs * rhs.
    /// @dev Reverts on overflow / underflow.
    function mul(int256 lhs, int256 rhs) public pure returns (int256 result) {
        assembly {
            // Perform the multiplication
            result := mul(lhs, rhs)

            // Check for overflow
            // To check for overflow, we verify that the result divided by one operand
            // equals the other operand, which would indicate that the multiplication was correct
            // Only check for overflow if neither operand is zero
            if iszero(
                or(
                    iszero(lhs),
                    iszero(rhs)
                )
            ) {
                // Check if result divided by lhs equals rhs
                if iszero(eq(sdiv(result, lhs), rhs)) {
                    revert(0, 0)
                }
            }
        }
    }

    /// @notice Returns lhs / rhs.
    /// @dev Reverts on division by zero.
    function div(int256 lhs, int256 rhs) public pure returns (int256 result) {
        assembly {
            // Revert if dividing by zero
            if iszero(rhs) {
                revert(0, 0)
            }
            if iszero(lhs) {
                revert(0, 0)
            }

            // Perform the division
            result := sdiv(lhs, rhs)
        }
       
    }
}
