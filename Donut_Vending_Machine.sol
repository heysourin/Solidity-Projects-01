//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract vendingMachine2{
    address payable public owner;
    mapping(address => uint) public donutAmount;

    constructor(uint _amt){
        owner = payable(msg.sender);
        donutAmount[address(this)] = _amt;
    }

    function seeAmount() public view returns(uint){
        return donutAmount[address(this)];
    }

    function buy(uint _amt) public payable{
        require(msg.value >= (_amt * 1 ether),"Cost: 1 ether per pc.");
        require(msg.sender != owner, "Owner can't make a purchase");
        require(donutAmount[address(this)] > _amt, "Not so much available");

        donutAmount[address(this)] -= 1;
        donutAmount[msg.sender] += 1;
    }

    function restock(uint _amt) public{
        require(msg.sender == owner, "Only owner can restock");
        donutAmount[address(this)] += _amt;
    }

    function withdrawBalance() public payable{
        require(msg.sender == owner, "Only owner can withdraw");
        
        //// Process 1:
        // owner.transfer(address(this).balance);

        // Process 2:
        bool sent = owner.send(address(this).balance);
        require(sent, "Transaction failed");
        
        //// Process 3:
        // owner.transfer(address(this).balance);
    }
}
