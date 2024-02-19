# MultiSigWallet Contract

This Solidity smart contract implements a multi-signature wallet, allowing multiple authorized signers to collectively approve and execute transactions.

## Overview

The MultiSigWallet contract requires a specified quorum of signers to approve a transaction before it can be executed. It supports functionalities like initiating transactions, approving transactions, adding valid signers, and transferring ownership.

## Features

- **Initiate Transaction:** Allows any valid signer to propose a transaction by specifying the amount and receiver address.
- **Approve Transaction:** Valid signers can approve a proposed transaction, and once the quorum is reached, the transaction is executed, transferring the specified amount to the designated receiver.
- **Add Valid Signer:** The owner can add new valid signers to the contract.
- **Transfer Ownership:** The owner can transfer ownership of the contract to another address, and the new owner must claim ownership to finalize the transfer.

## Contract Functions

- `initiateTransaction(uint256 _amount, address _receiver)`: Initiates a transaction proposal.
- `approveTransaction(uint256 _txId)`: Approves a transaction if the signer is valid and the quorum is not reached.
- `addValidSigner(address _newSigner)`: Allows the owner to add a new valid signer.
- `getAllTransactions()`: Retrieves all transactions initiated.
- `transferOwnership(address _newOwner)`: Initiates the transfer of ownership to a new address.
- `claimOwnership()`: Finalizes the transfer of ownership.

## Usage

To use this contract, deploy it on the Ethereum network with a list of initial valid signers and a specified quorum. After deployment, authorized signers can initiate and approve transactions according to the contract rules.
