// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UpgradeableMechSuit {
    address public implementation;

    /// @notice Constructs the contract
    /// @param _implementation Address of logic contract to be linked
    constructor(address _implementation) {
        implementation = _implementation;
    }

    /// @notice Upgrades contract by updating the linked logic contract
    /// @param _implementation Address of new logic contract to be linked
    function upgradeTo(address _implementation) external {
        implementation = _implementation;
    }

    /// @notice Fallback function to delegate calls to the implementation contract
    fallback() external payable {
        // Set up memory for the delegatecall
        assembly {
            let ptr := mload(0x40) // Load free memory pointer

            // (1) Copy incoming calldata into memory
            calldatacopy(ptr, 0, calldatasize())

            // (2) Forward call to implementation contract
            let result := delegatecall(gas(), sload(implementation.slot), ptr, calldatasize(), 0, 0)
            let size := returndatasize()

            // (3) Retrieve return data
            returndatacopy(ptr, 0, size)

            // (4) Forward return data back to caller
            switch result
            case 0 { revert(ptr, size) } // Revert if call failed
            default { return(ptr, size) } // Return if call succeeded
        }
    }

    // Optional: A receive function to support receiving Ether
    receive() external payable {}
}
