// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract UpgradeableMechSuit {

    bytes32 internal  _IMPLEMENTATION_SLOT  = bytes32(uint256(keccak256('eip1967.proxy.implementation')) - 1);

    bytes32 internal constant _ADMIN_SLOT = bytes32(uint256(keccak256('eip1967.proxy.admin')) - 1);

    function _getAddress(bytes32 slot) public view returns (address addr) {
        assembly {
            addr := sload(slot)
        }
    return addr;
    }
    function _setAddress(bytes32 slot, address addr) public {
        assembly {
            sstore(slot, addr)
        }
    }


    /// @notice Constructs the contract
    /// @param implementation Address of logic contract to be linked
    constructor (address implementation) {
        _setAddress(_ADMIN_SLOT, msg.sender);
        _setAddress(_IMPLEMENTATION_SLOT, implementation);
    }

    /// @notice Upgrades contract by updating the linked logic contract
    /// @param implementation Address of new logic contract to be linked
    function upgradeTo(address implementation) external {
        address admin = _getAddress(_ADMIN_SLOT);
        require(msg.sender == admin, "UpgradeableMechSuit: only admin can upgrade");
        _setAddress(_IMPLEMENTATION_SLOT, implementation);
        
    }

    /// @notice Fallback function to delegate calls to the implementation contract
    fallback() external payable {
        // Set up memory for the delegatecall
        assembly {
            let ptr := mload(0x40) // Load free memory pointer

            // (1) Copy incoming calldata into memory
            calldatacopy(ptr, 0, calldatasize())

            // (2) Forward call to implementation contract
            let result := delegatecall(gas(), sload(_IMPLEMENTATION_SLOT.slot), ptr, calldatasize(), 0, 0)
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
