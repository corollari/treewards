pragma solidity ^0.5.0;

contract TreeRewards {
    
    mapping (uint256 => address) public landOwner; // Keys will need to be retrieved using events
    mapping (address => uint256) public lastWeekClaimedByOwner;
    mapping (uint => uint) public moneyReceivedByWeek;
    mapping (uint => mapping (address => uint)) public forestedAreasByOwnerByWeek;
    mapping (uint => uint) public totalForestedAreasByWeek;
    
    event LandAssigned(uint256, address);
    
    uint256 public contractCreationTime;
    uint constant public claimPeriod = 1 weeks;
    address public owner; //Should use that erc but meh
    
    function time2period (uint time) view private returns (uint) {
        return ((time-contractCreationTime)/claimPeriod);
    }
    
    constructor () public {
        contractCreationTime = now;
        owner = msg.sender;
    }
    
    function claimRewards (uint NumWeeksToClaim) public {
        address payable claimer = msg.sender;
        uint startingWeek = lastWeekClaimedByOwner[claimer] + 1;
        require(startingWeek + NumWeeksToClaim <= time2period(now));
        for(uint week = startingWeek; week < (startingWeek + NumWeeksToClaim); week += 1){
            lastWeekClaimedByOwner[claimer] = week;
            claimer.transfer(forestedAreasByOwnerByWeek[week-1][claimer]/totalForestedAreasByWeek[week-1]);
        }
    }
    
    function submitOracle(uint week, address landOwnerToUpdate, uint forestedArea) external {
        require(msg.sender == owner);
        forestedAreasByOwnerByWeek[week][landOwnerToUpdate] += forestedArea;
        totalForestedAreasByWeek[week] += forestedArea;
    }
    
    function assignLand(address landOwnerToUpdate, uint landId) external {
        require(msg.sender == owner);
        landOwner[landId] = landOwnerToUpdate;
        emit LandAssigned(landId, landOwnerToUpdate);
    }
    
    function () external payable {
        // Trigger when ETH gets sent to the smart contract
        uint currentPeriod = time2period(now);
        moneyReceivedByWeek[currentPeriod] += msg.value;
    }
}
