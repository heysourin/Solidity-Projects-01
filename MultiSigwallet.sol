//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultisigWallet {
    event Deposit(address indexed sender, uint256 amoun, uint256 balance);
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed transactionId,
        address indexed transactionTo,
        uint256 value,
        bytes data
    );
    event transcactionConfirmation(
        address indexed owner,
        uint256 indexed transactionId
    );
    event revokeConfirmation(
        address indexed owner,
        uint256 indexed transactionId
    );
    event executeTranscaction(
        address indexed owner,
        uint256 indexed transactionId
    );

    address[] owners;
    mapping(address => bool) public isOwner;
    uint256 public numOfConfirmationRequired;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 numConfirms;
    }

    mapping(uint256 => mapping(address => bool)) public isConfirmed;

    Transaction[] transactions;

    
}
