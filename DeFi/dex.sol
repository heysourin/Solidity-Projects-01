// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract DEX {
    // Mapping from asset IDs to asset info
    mapping (uint => Asset) public assets;

    // Struct to store asset info
    struct Asset {
        address owner;
        uint balance;
    }

    // Mapping from user addresses to their token balances
    mapping (address => mapping (uint => uint)) public balances;

    // Function to add a new asset to the exchange
    function addAsset(uint id, uint initialSupply) public {
        require(assets[id].balance == 0, "Asset already exists.");

        // Set the initial asset info
        assets[id] = Asset({
            owner: msg.sender,
            balance: initialSupply
        });

        // Set the initial balance for the asset owner
        balances[msg.sender][id] = initialSupply;
    }

    // Function to buy an asset
    function buyAsset(uint id, uint amount) public payable {
        require(amount > 0, "Amount must be greater than zero.");
        require(assets[id].balance >= amount, "Insufficient asset supply.");

        // Calculate the total cost of the purchase
        uint cost = amount * assets[id].price;
        require(msg.value >= cost, "Insufficient funds.");

        // Transfer the assets to the buyer
        assets[id].owner.transfer(amount);
        balances[msg.sender][id] += amount;

        // Transfer the funds to the asset owner
        assets[id].owner.transfer(cost);
    }

    // Function to sell an asset
    function sellAsset(uint id, uint amount) public {
        require(amount > 0, "Amount must be greater than zero.");
        require(balances[msg.sender][id] >= amount, "Insufficient asset balance.");

        // Transfer the assets to the exchange
        assets[id].owner.transfer(amount);
        balances[msg.sender][id] -= amount;

        // Transfer the funds to the seller
        msg.sender.transfer(amount * assets[id].price);
    }

    // Function to get the balance of an asset for a given user
    function getBalance(address user, uint id) public view returns (uint) {
        return balances[user][id];
    }
}
