// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./EventManager.sol";

contract CertificateNFT is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // store token URIs
    mapping(uint256 => string) private _tokenURIs;

    // reference to EventManager
    EventManager private eventManager;

    event CertificateIssued(uint256 indexed certificateId, address indexed volunteer, uint256 eventId);

    constructor(address eventManagerAddress) ERC721("NSS Certificate", "NSSC") {
        eventManager = EventManager(eventManagerAddress);
    }

    function issueCertificate(
        address volunteer,
        uint256 eventId,
        string memory certificateUri
    ) external onlyOwner {
        require(eventManager.isRegistered(eventId, volunteer), "Volunteer not registered");
        _tokenIds.increment();
        uint256 newCertId = _tokenIds.current();
        _mint(volunteer, newCertId);
        _tokenURIs[newCertId] = certificateUri;
        emit CertificateIssued(newCertId, volunteer, eventId);
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return _tokenURIs[tokenId];
    }
}
