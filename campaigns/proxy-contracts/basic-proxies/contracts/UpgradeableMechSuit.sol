
// pragma solidity ^0.8.19;

// contract UpgradeableMechSuit {

//     address public implementation;
    
//     /// @notice Constructs the contract
//     /// @param _implementation Address of logic contract to be linked
//     constructor(address _implementation) { 
//         implementation = _implementation;
//     }

//     /// @notice Upgrades contract by updating the linked logic contract
//     /// @param _implementation Address of new logic contract to be linked
//     function upgradeTo(address _implementation) external {
//         implementation = _implementation;
//     }

//     /// @notice Fallback function that delegates calls to the linked logic contract
//     fallback() external payable {
//         _delegate(implementation);
//     }

//     /// @notice Receive function to handle ether transfers
//     receive() external payable {
//         _delegate(implementation);
//     }

//     /// @dev Internal function to delegate the call to the implementation contract
//     function _delegate(address _implementation) internal {
//         assembly {
//             // Copy the calldata (the input to the function being called)
//             calldatacopy(0, 0, calldatasize())

//             // Call the implementation contract
//             let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

//             // Copy the return data back
//             returndatacopy(0, 0, returndatasize())

//             // If the delegatecall fails, revert with the reason
//             if iszero(result) {
//                 revert(0, returndatasize())
//             }

//             // Return the data from the implementation contract
//             return(0, returndatasize())
//         }
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UpgradeableMechSuit {

    // EIP-1967 storage slots
    bytes32 internal constant _IMPLEMENTATION_SLOT = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);
    bytes32 internal constant _ADMIN_SLOT = bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1);

    /// @notice Constructs the contract and sets the admin and implementation addresses
    /// @param implementation Address of logic contract to be linked
    constructor(address implementation) {
        _setAddress(_ADMIN_SLOT, msg.sender); // Set the contract creator as admin
        _setAddress(_IMPLEMENTATION_SLOT, implementation); // Set the implementation address
    }

    /// @notice Upgrades contract by updating the linked logic contract, restricted to admin
    /// @param implementation Address of new logic contract to be linked
    function upgradeTo(address implementation) external {
        require(msg.sender == _getAddress(_ADMIN_SLOT), "UpgradeableMechSuit: Only admin can upgrade");
        _setAddress(_IMPLEMENTATION_SLOT, implementation);
    }

    /// @notice Fallback function that delegates calls to the linked logic contract
    fallback() external payable {
        _delegate(_getAddress(_IMPLEMENTATION_SLOT));
    }

    /// @notice Receive function to handle ether transfers
    receive() external payable {
        _delegate(_getAddress(_IMPLEMENTATION_SLOT));
    }

    /// @dev Helper function to read an address from a storage slot
    function _getAddress(bytes32 slot) public view returns (address addr) {
        assembly {
            addr := sload(slot)
        }
        return addr;
    }

    /// @dev Helper function to write an address to a storage slot
    function _setAddress(bytes32 slot, address addr) internal {
        assembly {
            sstore(slot, addr)
        }
    }

    /// @dev Internal function to delegate the call to the implementation contract
    function _delegate(address implementation) internal {
        assembly {
            // Copy the calldata (the input to the function being called)
            calldatacopy(0, 0, calldatasize())

            // Call the implementation contract
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the return data back
            returndatacopy(0, 0, returndatasize())

            // If the delegatecall fails, revert with the reason
            if iszero(result) {
                revert(0, returndatasize())
            }

            // Return the data from the implementation contract
            return(0, returndatasize())
        }
    }
}
