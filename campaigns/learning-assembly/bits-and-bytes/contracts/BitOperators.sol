// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BitOperators {

    /// @notice Returns x << shift.
    function shiftLeft(uint256 x, uint256 shift)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            rvalue := shl(shift, x)
        }
        return rvalue;
    }

    /// @notice Sets the bit at `index` in `x` to `1`.
    /// @return rvalue value with the set bit
    function setBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            rvalue := or(x, shl(index, 1))
        }
        return rvalue;
    }

    /// @notice Clears the bit at `index` in `x` to `0`.
    /// @return rvalue value with the cleared bit
    function clearBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            rvalue := and(x, not(shl(index, 1)))
        }
        return rvalue;
    }

    /// @notice Flips the bit at `index` in `x`.
    /// @return rvalue value with the flipped bit
    function flipBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            rvalue := xor(x, shl(index, 1))
        }
        return rvalue;
    }

    /// @notice Gets the bit at `index` in `x`.
    /// @return rvalue 1 if queried bit is `1`, 0 otherwise.
    function getBit(uint256 x, uint256 index)
        public
        pure
        returns (uint256 rvalue)
    {
        assembly {
            rvalue := and(shr(index, x), 1)
        }
        return rvalue;
    }
}
