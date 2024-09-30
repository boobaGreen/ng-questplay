// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Mind {
    address immutable deploymentAddress ;
    /// @notice This could be useful...
    constructor() {
        deploymentAddress = address(this);
    }

    /// @notice Checks if the current call is a delegate call.
    /// @return isDelegate true if this is a delegate call, false otherwise.
    function isDelegateCall() public view returns (bool isDelegate) {
         // Se address(this) è diverso dall'indirizzo di distribuzione, è una delegate call
        return address(this) != deploymentAddress;
    }
}
