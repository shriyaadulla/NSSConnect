// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NSSConnect is Ownable, Pausable, ERC721 {
    using Counters for Counters.Counter;
    
    // Counters for IDs
    Counters.Counter private _eventIds;
    Counters.Counter private _fundIds;
    Counters.Counter private _certificateIds;
    
    // Event struct
    struct Event {
        uint256 id;
        string name;
        string description;
        uint256 startTime;
        uint256 endTime;
        uint256 requiredVolunteers;
        uint256 registeredVolunteers;
        bool isActive;
    }
    
    // Fund struct
    struct Fund {
        uint256 id;
        string name;
        string description;
        uint256 targetAmount;
        uint256 raisedAmount;
        bool isActive;
    }
    
    // Certificate struct
    struct Certificate {
        uint256 id;
        address volunteer;
        uint256 eventId;
        uint256 volunteerHours;
        uint256 timestamp;
    }
    
    // Mappings
    mapping(uint256 => Event) public events;
    mapping(uint256 => Fund) public funds;
    mapping(uint256 => Certificate) public certificates;
    mapping(address => mapping(uint256 => bool)) public userEvents;
    mapping(address => uint256[]) public userCertificates;
    mapping(address => mapping(uint256 => bool)) public userContributions;
    
    // Events
    event ContractDeployed(address owner);
    event EventCreated(uint256 indexed eventId, string name);
    event EventRegistered(uint256 indexed eventId, address indexed volunteer);
    event FundCreated(uint256 indexed fundId, string name);
    event FundContributed(uint256 indexed fundId, address indexed contributor, uint256 amount);
    event CertificateIssued(uint256 indexed certificateId, address indexed volunteer);
    
    constructor() ERC721("NSSConnect Certificate", "NSSC") {
        emit ContractDeployed(msg.sender);
    }
    
    // Event Management
    function createEvent(
        string memory name,
        string memory description,
        uint256 startTime,
        uint256 endTime,
        uint256 requiredVolunteers
    ) external onlyOwner {
        require(startTime < endTime, "Invalid time range");
        
        _eventIds.increment();
        uint256 eventId = _eventIds.current();
        
        events[eventId] = Event(
            eventId,
            name,
            description,
            startTime,
            endTime,
            requiredVolunteers,
            0,
            true
        );
        
        emit EventCreated(eventId, name);
    }
    
    function registerForEvent(uint256 eventId) external whenNotPaused {
        require(events[eventId].isActive, "Event is not active");
        require(block.timestamp >= events[eventId].startTime, "Event registration not started");
        require(block.timestamp <= events[eventId].endTime, "Event registration ended");
        require(events[eventId].registeredVolunteers < events[eventId].requiredVolunteers, "Event is full");
        require(!userEvents[msg.sender][eventId], "Already registered");
        
        events[eventId].registeredVolunteers++;
        userEvents[msg.sender][eventId] = true;
        
        emit EventRegistered(eventId, msg.sender);
    }
    
    // Fund Management
    function createFund(
        string memory name,
        string memory description,
        uint256 targetAmount
    ) external onlyOwner {
        _fundIds.increment();
        uint256 fundId = _fundIds.current();
        
        funds[fundId] = Fund(
            fundId,
            name,
            description,
            targetAmount,
            0,
            true
        );
        
        emit FundCreated(fundId, name);
    }
    
    function contributeToFund(uint256 fundId) external payable whenNotPaused {
        require(funds[fundId].isActive, "Fund is not active");
        require(msg.value > 0, "Contribution amount must be greater than 0");
        
        funds[fundId].raisedAmount += msg.value;
        userContributions[msg.sender][fundId] = true;
        
        emit FundContributed(fundId, msg.sender, msg.value);
    }
    
    // Certificate Management
    function issueCertificate(
        address volunteer,
        uint256 eventId,
        uint256 volunteerHours
    ) external onlyOwner {
        require(events[eventId].isActive, "Event is not active");
        require(events[eventId].registeredVolunteers > 0, "No volunteers registered");
        
        _certificateIds.increment();
        uint256 certificateId = _certificateIds.current();
        
        certificates[certificateId] = Certificate(
            certificateId,
            volunteer,
            eventId,
            volunteerHours,
            block.timestamp
        );
        
        _mint(volunteer, certificateId);
        userCertificates[volunteer].push(certificateId);
        
        emit CertificateIssued(certificateId, volunteer);
    }
    
    // View Functions
    function getEvent(uint256 eventId) external view returns (
        uint256,
        string memory,
        string memory,
        uint256,
        uint256,
        uint256,
        uint256,
        bool
    ) {
        Event storage eventInfo = events[eventId];
        return (
            eventInfo.id,
            eventInfo.name,
            eventInfo.description,
            eventInfo.startTime,
            eventInfo.endTime,
            eventInfo.requiredVolunteers,
            eventInfo.registeredVolunteers,
            eventInfo.isActive
        );
    }
    
    function getFund(uint256 fundId) external view returns (
        uint256,
        string memory,
        string memory,
        uint256,
        uint256,
        bool
    ) {
        Fund storage fundInfo = funds[fundId];
        return (
            fundInfo.id,
            fundInfo.name,
                        fundInfo.description,
            fundInfo.targetAmount,
            fundInfo.raisedAmount,
            fundInfo.isActive
        );
    }
    
    function getCertificate(uint256 certificateId) external view returns (
        uint256,
        address,
        uint256,
        uint256,
        uint256
    ) {
        Certificate storage certInfo = certificates[certificateId];
        return (
            certInfo.id,
            certInfo.volunteer,
            certInfo.eventId,
            certInfo.volunteerHours,
            certInfo.timestamp
        );
    }
    
    function getUserCertificates(address user) external view returns (uint256[] memory) {
        return userCertificates[user];
    }
    
    // Admin Functions
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
    
    function withdrawFunds(uint256 fundId, address payable recipient) external onlyOwner {
        require(funds[fundId].raisedAmount > 0, "No funds to withdraw");
        
        uint256 amount = funds[fundId].raisedAmount;
        funds[fundId].raisedAmount = 0;
        
        recipient.transfer(amount);
    }
}