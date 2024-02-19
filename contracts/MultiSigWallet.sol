// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

//this contract should have ether for it to function as supposed
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

    //the _validSigners should be array of stringed address
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

    //method to initiate transaction
    function initiateTransaction(uint256 _amount, address _receiver) external {
        require(msg.sender != address(0), "zero address detected");
        require(_amount > 0, "no zero value allowed");

        onlyValidSigner();

        uint256 _txId = txCount + 1;

        Transaction storage tns = transactions[_txId];

        tns.id = _txId;
        tns.amount = _amount;
        tns.receiver = _receiver;
        tns.signersCount = tns.signersCount + 1;
        tns.txCreator = msg.sender;

        allTransactions.push(tns);

        hasSigned[_txId][msg.sender] = true;

        txCount = txCount + 1;
    }

    //approve transaction
    //this method would transfer the ether if the quorum is reached
    function approveTransaction(uint256 _txId) external {
        require(_txId <= txCount, "invalid transaction id");
        require(msg.sender != address(0), "zero address detected");

        onlyValidSigner();

        require(!hasSigned[_txId][msg.sender], "can't sign twice");
        Transaction storage tns = transactions[_txId];
        require(
            address(this).balance >= tns.amount,
            "insufficient contract balance"
        );

        require(!tns.isExecuted, "transaction already executed");
        require(tns.signersCount < quorum, "quorum count reached");

        tns.signersCount = tns.signersCount + 1;

        hasSigned[_txId][msg.sender] = true;

        if (tns.signersCount == quorum) {
            tns.isExecuted = true;
            payable(tns.receiver).transfer(tns.amount);
        }
    }
}
