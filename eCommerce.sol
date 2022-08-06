//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract ecommerce{

    struct Product{
        string title;
        string descrp;
        address payable seller;
        uint serialNum;
        uint price;
        address buyer;
        bool isDelivered;
    }

    uint count = 1;
    Product[] public products;

    event registered(string title, uint serialNum, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerproduc(string memory _title, string memory _descrp, uint _price) public{
        require(_price > 0, "Should be greater than zero");

        Product memory tempProduct;
        tempProduct.title = _title;
        tempProduct.descrp = _descrp;
        tempProduct.price = _price * 10 ** 18;///converting ether into wei
        tempProduct.seller = payable(msg.sender);
        tempProduct.serialNum = count;
        count++;

        products.push(tempProduct);
        emit registered(_title, tempProduct.serialNum, msg.sender);
    } 

    function buy(uint _serialNum) payable public{
        require(products[_serialNum-1].price == msg.value,"Pay the exact price");
        require(products[_serialNum-1].seller != msg.sender,"Seller can't buy");

        products[_serialNum-1].buyer = msg.sender;
        emit bought(_serialNum,msg.sender);
    }

    function delivery(uint _serialNum) public{
        require(products[_serialNum-1].buyer == msg.sender, "Only buyer can confirm this");
        products[_serialNum-1].isDelivered = true;
        products[_serialNum-1].seller.transfer(products[_serialNum-1].price);
        emit delivered(_serialNum);
    }
}
