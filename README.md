# 🧾 InheritanceManager Smart Contract – Solidity


## This smart contract securely manages digital inheritance on Ethereum. It allows a contract owner to assign beneficiaries who can claim funds if the owner becomes inactive for a set period (default: 90 days). The contract:

Tracks the owner's activity using block.timestamp
Allows beneficiaries to trigger inheritance after inactivity
Ensures fair fund distribution among all listed beneficiaries
Prevents double claiming with hasClaimed checks
Uses ReentrancyGuard to prevent exploit risks
Automatically updates activity when funds are received
Built with Solidity ^0.8.18, using OpenZeppelin’s Ownable and ReentrancyGuard.
