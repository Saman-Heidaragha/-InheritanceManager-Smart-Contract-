// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract InheritanceManager is Ownable, ReentrancyGuard {
    
    uint256 public constant INACTIVITY_PERIOD = 90 days;
    uint256 public lastActivity;

    address[] public beneficiaries;
    mapping(address => bool) public isBeneficiary;
    mapping(address => bool) public hasClaimed;

    bool public isInheritanceUnlocked;

    constructor(address initialOwner) Ownable(initialOwner) {
        lastActivity = block.timestamp;
    }

    modifier onlyOwnerActive() {
        require(msg.sender == owner(), "Not the Owner");
        _;
        lastActivity = block.timestamp;
    }

    function addBeneficiary(address _beneficiary) public onlyOwnerActive {
        require(_beneficiary != address(0), "Invalid address");
        require(!isBeneficiary[_beneficiary], "Already a beneficiary");

        beneficiaries.push(_beneficiary);
        isBeneficiary[_beneficiary] = true;
    }

    function triggerInheritance() external {
        require(isBeneficiary[msg.sender], "Not a beneficiary");
        require(block.timestamp >= lastActivity + INACTIVITY_PERIOD, "Owner still active!");
        isInheritanceUnlocked = true;
    }

    function withdrawInheritedFunds() external nonReentrant {
        require(isInheritanceUnlocked, "Inheritance not unlocked");
        require(isBeneficiary[msg.sender], "Not a beneficiary");
        require(!hasClaimed[msg.sender], "Already claimed");

        uint256 share = address(this).balance / beneficiaries.length;
        require(share > 0, "No funds");

        hasClaimed[msg.sender] = true;
        payable(msg.sender).transfer(share);
    }
    
    function getBeneficiaries() external view returns (address[] memory) {
        return beneficiaries;
    }
    
    receive() external payable {
        lastActivity = block.timestamp;
    }

    fallback() external payable { 
        lastActivity = block.timestamp;
    }

 
}
