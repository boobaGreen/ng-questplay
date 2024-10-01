// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/IVillageFunding.sol";

//TEMP
import "hardhat/console.sol";
//

contract VillageFunding /* is IVillageFunding */ {
struct ProjectRecord {
        address owner;
        uint256 fundsRaised;
        uint256 numberofContributors;
        bool claimed;
        uint256 finalAmountPerProject;
    }
    bool public isFinalized;
    uint256 public matchingAmount;
    mapping(address => bool) public isVillager; // To check if an address is a villager
    address[] public projectsList; // List of project addresses
    address[] public villagersList; // List of villager addresses
    mapping(address => ProjectRecord) public projectsDatabase; // 
    uint256 public startTime; // Timestamp di inizio della raccolta fondi
      // Mapping to track contributions by each villager to each project
    mapping(address => mapping(address => uint256)) public contributions; // villager => project => amount
    mapping(address => mapping(address => bool)) public hasContributed; // villager => project => contributed?


    modifier onlyVillager() {
        require(isVillager[msg.sender], "Only villagers can contribute");
        _;
    }

    modifier onlyDuringVoting() {
        require(block.timestamp <= startTime + 7 days, "Voting period has ended");
        _;
    }

    modifier onlyValidProject(address _project) {
        require(projectsDatabase[_project].owner != address(0), "Invalid project");
        _;
    }
    constructor(
        address[] memory _villagers, 
        address[] memory _projects
    ) payable {
        require(_villagers.length > 0, "No villagers");
        require(_projects.length > 0, "No projects");


        require(msg.value> 0, "Invalid matching amount");
        
        startTime = block.timestamp;
        matchingAmount = msg.value;
        projectsList = _projects;
        villagersList = _villagers;

        for (uint256 i = 0; i < _projects.length; i++) {
            projectsDatabase[_projects[i]] = ProjectRecord({
                fundsRaised: 0,
                owner: _projects[i],
                claimed: false,
                finalAmountPerProject: 0,
                numberofContributors: 0
            });
        }

        for (uint256 i = 0; i < _villagers.length; i++) {
            isVillager[_villagers[i]] = true; // Mark addresses as villagers
        }
    }

    // Restituisce gli indirizzi dei progetti
    function getProjects() external view returns (address[] memory) {

        address[] memory projects = new address[](projectsList.length);
        for (uint256 i = 0; i < projectsList.length; i++) {
            projects[i] = projectsList[i];
        }
        return projects;
    
    }

      // Restituisce i fondi finali di un progetto
    function finalFunds(address _project) external view  returns (uint256) {

        if (isFinalized) {
            if (projectsDatabase[_project].claimed) {
                return 0;
            } else {
                return projectsDatabase[_project].finalAmountPerProject;
            }
        } else {
            return 0;
        }

    }

   function finalizeFunds() external {
    require(!isFinalized, "Funds have already been finalized");
    require(block.timestamp > startTime + 7 days, "Funding period has not ended yet");
    
    uint256 totalFundsToDistribute = matchingAmount;

    // Array to hold the sum of square roots of contributions for each project
    uint256[] memory m = new uint256[](projectsList.length);    
  
    uint256 totalMatchingPower = 0; // Total sum of squares of matching power

    // Calculate the sum of square roots of contributions for each project
    for (uint256 i = 0; i < projectsList.length; i++) {
        m[i] = 0; // Reset m[i] for the current project
        address project = projectsList[i];


        // Calculate the sum of square roots of contributions to this project
        for (uint256 j = 0; j < villagersList.length; j++) {

            address villager =  villagersList[j];
           
            uint256 contribution = contributions[project][villager];
         
            // Only add the square root of the contribution if it is greater than 0
            if (contribution > 0) {
                m[i] += sqrt(contribution); // Adding the square root of contributions
   
            }
        }

        // Calculate the square of matching power
        totalMatchingPower += m[i] * m[i]; // m_j^2
 
     
     
      
    }

    // Distribute funds based on matching power
    for (uint256 i = 0; i < projectsList.length; i++) {
        if (totalMatchingPower > 0) {
            // Allocate funds to each project
            projectsDatabase[projectsList[i]].finalAmountPerProject = 
                ((totalFundsToDistribute * m[i] * m[i]) / totalMatchingPower)+projectsDatabase[projectsList[i]].fundsRaised;
        } else {
            projectsDatabase[projectsList[i]].finalAmountPerProject = 0; // No funds to distribute if no contributions
        }
    }

    isFinalized = true; // Mark the funds as finalized
}

    // Function to compute the square root of a number
    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint z = (x + 1) / 2;
        y = x;
            while (z < y) { 
                y = z;
                z = (x / z + z) / 2;
            }
    }







    function donate(address _project) external payable onlyVillager onlyDuringVoting onlyValidProject(_project) {
       
        require(!hasContributed[msg.sender][_project], "Villager has already contributed to this project");
        require(msg.value > 0, "Contribution must be greater than 0");
 
        projectsDatabase[_project].fundsRaised += msg.value;
        projectsDatabase[_project].numberofContributors += 1;
        hasContributed[msg.sender][_project] = true;
        contributions[_project][msg.sender] += msg.value;
    
    }

 

    function withdraw() external onlyValidProject(msg.sender) {
    // Check if funds have been finalized
    require(isFinalized, "Funds have not been finalized yet");
    
    // Check if the project has already been claimed
    require(!projectsDatabase[msg.sender].claimed, "Funds have already been claimed");

    // Retrieve the amount allocated for withdrawal
    uint256 amountToWithdraw = projectsDatabase[msg.sender].finalAmountPerProject;

    // Ensure there are funds available to withdraw
    require(amountToWithdraw > 0, "No funds available for withdrawal");

    // Mark the project as claimed to prevent double withdrawals
    projectsDatabase[msg.sender].claimed = true;

    // Transfer the funds to the project owner
    (bool success, ) = msg.sender.call{value: amountToWithdraw}("");
    
    // Ensure the transfer was successful
    require(success, "Transfer failed");
}

}
