// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NSSCertificate is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _eventIds;
    Counters.Counter private _tokenIds;

    // store token URIs
    mapping(uint256 => string) private _tokenURIs;

    struct Event {
        uint256 id;
        string title;
        string description;
        uint256 date;            // timestamp of event
        uint256 maxVolunteers;
        string location;
        string category;
        string imageUrl;
        uint256 registeredCount;
        bool isActive;
    }

    struct Certificate {
        uint256 id;
        address volunteer;
        uint256 eventId;
        uint256 volunteerHours;
        uint256 issuedDate;
        string certificateUrl;
    }

    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(address => bool)) public isRegistered;
    mapping(uint256 => Certificate) public certificates;
    mapping(address => uint256[]) public userCertificates;

    event EventCreated(uint256 indexed eventId, string title);
    event EventRegistered(uint256 indexed eventId, address indexed volunteer);
    event CertificateIssued(uint256 indexed certificateId, address indexed volunteer, uint256 eventId);

    constructor() ERC721("NSS Certificate", "NSSC") {}

    // internal: set a token's URI
    function _setTokenURI(uint256 tokenId, string memory uri) internal virtual {
        _tokenURIs[tokenId] = uri;
    }

    // override metadata URI function
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }

    function createEvent(
        string memory title,
        string memory description,
        uint256 date,
        uint256 maxVolunteers,
        string memory location,
        string memory category,
        string memory imageUrl
    ) external onlyOwner {
        _eventIds.increment();
        uint256 eventId = _eventIds.current();
        events[eventId] = Event(
            eventId,
            title,
            description,
            date,
            maxVolunteers,
            location,
            category,
            imageUrl,
            0,
            true
        );
        emit EventCreated(eventId, title);
    }

    function registerForEvent(uint256 eventId) external {
        Event storage evt = events[eventId];
        require(evt.isActive, "Event not active");
        require(evt.registeredCount < evt.maxVolunteers, "Event full");
        require(!isRegistered[eventId][msg.sender], "Already registered");
        isRegistered[eventId][msg.sender] = true;
        evt.registeredCount++;
        emit EventRegistered(eventId, msg.sender);
    }

    function issueCertificate(
        address volunteer,
        uint256 eventId,
        uint256 volunteerHours,
        string memory certificateUrl
    ) external onlyOwner {
        Event storage evt = events[eventId];
        require(evt.isActive, "Event not active");
        require(isRegistered[eventId][volunteer], "Volunteer not registered");

        _tokenIds.increment();
        uint256 certId = _tokenIds.current();
        _mint(volunteer, certId);
        _setTokenURI(certId, certificateUrl);

        certificates[certId] = Certificate(
            certId,
            volunteer,
            eventId,
            volunteerHours,
            block.timestamp,
            certificateUrl
        );
        userCertificates[volunteer].push(certId);
        emit CertificateIssued(certId, volunteer, eventId);
    }

    function getEvent(uint256 eventId) external view returns (Event memory) {
        return events[eventId];
    }

    function getUserCertificates(address user) external view returns (uint256[] memory) {
        return userCertificates[user];
    }

    function getCertificate(uint256 certId) external view returns (Certificate memory) {
        return certificates[certId];
    }
}
