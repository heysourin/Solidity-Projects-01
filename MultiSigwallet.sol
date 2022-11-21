//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract MultisigWallet {
    event Deposit(address indexed sender, uint256 amoun, uint256 balance);
    event SubmitTransaction(
        address indexed owner,
        uint256 indexed transactionId,
        address indexed transactionTo,
        uint value,
        bytes data
    );
    event transcactionConfirmation(address indexed owner, uint indexed transactionId);
    event revokeConfirmation(address indexed owner, uint indexed transactionId);
    event executeTranscaction(address indexed owner, uint indexed transactionId);

    
}
