//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.8;

contract ecommerce{
    struct Item{
        string name;
        string description;
        address payable seller;
        uint itemId;
        uint price;//input price is in wei
        address buyer;
        bool isDelivered;//default: false
    }
    uint itemCount = 1;
    Item[] public items;

    event registered(string name, uint itemId, address seller);
    event bought(uint itemId, address buyer);
    event delivered(uint itemId, bool isDelivered);


    function productAddBySeller(string memory _name, string memory _description, uint _price) public {
        require(_price > 0, "Price must be greater than 0");
        
        Item memory tempItem;

        tempItem.name = _name;
        tempItem.description = _description;
        tempItem.price = _price ;
        tempItem.seller = payable(msg.sender);
        tempItem.itemId = itemCount;

        itemCount++;

        items.push(tempItem);

        emit registered(_name, tempItem.itemId, msg.sender);
    }

    function buy(uint _itemId) public payable{
        //itemId = index - 1
        require(items[_itemId-1].price == msg.value, "Please pay the exact price");
        require(msg.sender != items[_itemId-1].seller, "Seller Can't buy");


        items[_itemId-1].buyer = msg.sender;

        emit bought(_itemId, msg.sender);
    }
//PS: Dont input index number while "buy" or "delivery"

    function delivery(uint _itemId) public{
        require(items[_itemId-1].buyer == msg.sender, "Only buyer can confirm the delivery");

        items[_itemId-1].isDelivered = true;

        uint x = items[_itemId-1].price;
        items[_itemId-1].seller.transfer(x-((30*x)/100)); //30% commission of the ecommerce site

        emit delivered(_itemId, items[_itemId-1].isDelivered);
    }
}
