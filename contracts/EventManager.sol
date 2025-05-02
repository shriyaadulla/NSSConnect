// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/utils/Counters.sol";

contract EventManager {
    using Counters for Counters.Counter;
    Counters.Counter private _eventIds;

    struct Event {
        uint256 id;
        string title;
        string description;
        uint256 date;
        uint256 maxVolunteers;
    }

    mapping(uint256 => Event) private events;
    mapping(uint256 => mapping(address => bool)) public isRegistered;
    mapping(uint256 => uint256) public volunteerHours;
    uint256[] private eventList;

    event EventCreated(
        uint256 indexed eventId,
        string title,
        string description,
        uint256 date,
        uint256 maxVolunteers
    );
    event VolunteerRegistered(uint256 indexed eventId, address indexed volunteer);
    event HoursLogged(uint256 indexed eventId, address indexed volunteer, uint256 numHours);

    function createEvent(
        string calldata title,
        string calldata description,
        uint256 date,
        uint256 maxVolunteers
    ) external {
        _eventIds.increment();
        uint256 id = _eventIds.current();
        events[id] = Event(id, title, description, date, maxVolunteers);
        eventList.push(id);
        emit EventCreated(id, title, description, date, maxVolunteers);
    }

    function registerForEvent(uint256 eventId) external {
        require(events[eventId].id != 0, "Event does not exist");
        isRegistered[eventId][msg.sender] = true;
        emit VolunteerRegistered(eventId, msg.sender);
    }

    function logVolunteerHours(uint256 eventId, uint256 numHours) external {
        require(isRegistered[eventId][msg.sender], "Not registered");
        volunteerHours[eventId] += numHours;
        emit HoursLogged(eventId, msg.sender, numHours);
    }

    function getEvent(uint256 eventId)
        external
        view
        returns (
            string memory,
            string memory,
            uint256,
            uint256,
            uint256
        ) {
        Event storage e = events[eventId];
        return (e.title, e.description, e.date, 0, e.maxVolunteers);
    }

    function getAllEvents() external view returns (uint256[] memory) {
        return eventList;
    }

    /// Returns the total number of events created
    function getEventCount() external view returns (uint256) {
        return _eventIds.current();
    }
}
