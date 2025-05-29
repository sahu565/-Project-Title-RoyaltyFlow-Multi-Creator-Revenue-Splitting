// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract RoyaltyFlow {
    address public admin;

    struct Recipient {
        address wallet;
        uint256 percentage; // In basis points (e.g., 1000 = 10%)
    }

    mapping(uint256 => Recipient[]) public royalties;
    uint256 public workIdCounter;

    event RoyaltyRegistered(uint256 workId, Recipient[] recipients);
    event RoyaltyDistributed(uint256 workId, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    function registerRoyalty(Recipient[] memory recipients) public returns (uint256) {
        uint256 workId = workIdCounter++;
        uint256 totalPercent = 0;

        for (uint i = 0; i < recipients.length; i++) {
            royalties[workId].push(recipients[i]);
            totalPercent += recipients[i].percentage;
        }

        require(totalPercent == 10000, "Total percentage must equal 100%");
        emit RoyaltyRegistered(workId, recipients);
        return workId;
    }

    function distributeRoyalty(uint256 workId) public payable {
        require(msg.value > 0, "No funds sent");
        Recipient[] memory recipients = royalties[workId];
        require(recipients.length > 0, "No recipients");

        for (uint i = 0; i < recipients.length; i++) {
            uint256 share = (msg.value * recipients[i].percentage) / 10000;
            payable(recipients[i].wallet).transfer(share);
        }

        emit RoyaltyDistributed(workId, msg.value);
    }
}
