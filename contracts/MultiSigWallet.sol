// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract MultiSigWallet {
    address owner;
    address nextOwner;
    address[] signers;

    uint256 quorum;
    uint256 txCount;
}
