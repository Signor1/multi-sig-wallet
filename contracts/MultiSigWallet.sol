// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract MultiSigWallet {
    address owner;
    address nextOwner;
    address[] signers;

    uint256 quorum;
    uint256 txCount;

    struct Transaction {
        uint256 id;
        uint256 amount;
        address receiver;
        uint256 signersCount;
        bool isExecuted;
        address txCreator;
    }

    Transaction[] allTransactions;

    // mapping of transaction id to signer address returning bool:
    // this checks if a valid signer has signed a trasaction
    mapping(uint256 => mapping(address => bool)) hasSigned;

    // mapping of transaction id to transaction struct
    // used to track transactions given their ID;
    mapping(uint256 => Transaction) transactions;

    //mapping of address to bool
    //used to check the list of true signers
    mapping(address => bool) isValidSigner;

    constructor(address[] memory _validSigners, uint256 _quorum) {
        owner = msg.sender;
        signers = _validSigners;
        quorum = _quorum;

        for (uint8 i = 0; i < _validSigners.length; i++) {
            //checking if any of the addresses is a zero address
            require(_validSigners[i] != address(0), "get out");

            isValidSigner[_validSigners[i]] = true;
        }
    }
}
