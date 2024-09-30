// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract GreatScribe {

    /**
     * @dev Executes a batch of read-only calls on `archives`.
     * @param calls The sequence of ABI calldata of the read-only calls to forward to `archives`.
     * @param archives Address of the {GreatArchives} to read from.
     *
     * @return results Returns array of call results represented as bytes.
     */
    function multiread(
        bytes[] calldata calls,
        address archives
    ) external view returns (bytes[] memory results) {
        // Initialize an array to store the results
        results = new bytes[](calls.length);
        
        // Loop through each calldata and forward it to the target contract using staticcall
        for (uint256 i = 0; i < calls.length; i++) {
            // Perform the low-level staticcall
            (bool success, bytes memory result) = archives.staticcall(calls[i]);

            // Check if the call succeeded
            require(success, "Call failed!");

            // Store the result in the results array
            results[i] = result;
        }

        // Return the results
        return results;
    }
    
    /**
     * @dev Executes a batch of read/write transactions on `archives`.
     * @param calls The sequence of ABI calldata of the transactions to forward to `archives`.
     * @param archives Address of the {GreatArchives} to write onto.
     *
     * @return results Returns array of call results represented as bytes.
     */
    function multiwrite(
        bytes[] calldata calls,
        address archives
    ) external returns (bytes[] memory results) {
        // Initialize an array to store the results
        results = new bytes[](calls.length);
        
        // Loop through each calldata and forward it to the target contract using call
        for (uint256 i = 0; i < calls.length; i++) {
            // Perform the low-level call
            (bool success, bytes memory result) = archives.call(calls[i]);

            // Check if the call succeeded
            require(success, "Call failed!");

            // Store the result in the results array
            results[i] = result;
        }

        // Return the results
        return results;
    }

}
