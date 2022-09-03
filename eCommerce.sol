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
    address payable public manager;

    bool destroyed = false;

    modifier isNotDestroyed{
        require(!destroyed, "Contract does not exist");
        _;
    }
    constructor(){
        manager = payable(msg.sender);
    }

    event registered(string title, uint serialNum, address seller);
    event bought(uint productId, address buyer);
    event delivered(uint productId);

    function registerproduc(string memory _title, string memory _descrp, uint _price) public isNotDestroyed{
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

    function buy(uint _serialNum) payable public isNotDestroyed{
        require(products[_serialNum-1].price == msg.value,"Pay the exact price");
        require(msg.sender != items[_itemId-1].seller, "Seller Can't buy");


        products[_serialNum-1].buyer = msg.sender;
        emit bought(_serialNum,msg.sender);
    }

    function delivery(uint _serialNum) public isNotDestroyed{
        require(products[_serialNum-1].buyer == msg.sender, "Only buyer can confirm this");
        products[_serialNum-1].isDelivered = true;
        products[_serialNum-1].seller.transfer(products[_serialNum-1].price);
        emit delivered(_serialNum);
    }

    // function destroy() public{
    //     require(msg.sender == manager, "Only manager can call this function");
    //     selfdestruct(manager);// contract will be destroyed annd all the funds in the contract will be transfered to the manager
    //     //Why: to be safe from hacker
    // }

    function destroy() public isNotDestroyed{
        require(manager == msg.sender);
        manager.transfer(address(this).balance);
        destroyed = true;
    }

    fallback() payable external{
        payable(msg.sender).transfer(msg.value);
    }    
}
