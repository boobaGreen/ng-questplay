// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

library LibMap {
    struct MapStorage {
        string currentLocation;
        mapping(string => mapping(string => bool)) hasPath; 
    }

    bytes32 constant MAP_STORAGE_POSITION = keccak256("libmap.map.storage");

    function mapStorage() private pure returns (MapStorage storage map) {
        bytes32 position = MAP_STORAGE_POSITION;
        assembly {
            map.slot := position
        }
    }

    /// @notice Adds the path `from -> to` to the set of known paths.
    function addPath(string memory from, string memory to) internal {
        // Set the current location to "harbor" if it is not set
        if (bytes(mapStorage().currentLocation).length == 0) {
            mapStorage().currentLocation = "harbor";
        }

        // Add the path from `from` to `to`
        mapStorage().hasPath[from][to] = true;
    }

    /// @notice If the path `currentLocation() -> to` is known, sets current location as `to` and returns true.
    /// If path is not known, returns false.
    function travel(string memory to) internal returns (bool) {
        string storage currentLoc = mapStorage().currentLocation;

        // Check if the path from current location to `to` exists
        if (mapStorage().hasPath[currentLoc][to]) {
            mapStorage().currentLocation = to; // Update current location
            return true;
        }

        return false; // Path not known
    }

    /// @notice Returns current location.
    /// Initially set to "harbor".
    function currentLocation() internal view returns (string memory) {
        // Return the current location, defaulting to "harbor" if not set
        string storage loc = mapStorage().currentLocation;
        return bytes(loc).length == 0 ? "harbor" : loc;
    }
}
