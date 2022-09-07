
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract HolidayVilla{
    struct Villa{
        string name;
        uint villaId;
        address customer;
        bool isBooked;
    }

    address payable public VillaOwner;

    mapping (address => Villa) public villa;

    constructor(){
        VillaOwner = payable (msg.sender);
    }

    function villaBook(string memory _name, uint _villaId) public payable{
        require(msg.value >= 1 ether, "Minimum room cost 1 ether");
        villa[msg.sender] = Villa(_name, _villaId, msg.sender, true);
    }

    function withdrawAmount() public {
        require(msg.sender == VillaOwner, "Only owner can withdraw the balance");
        VillaOwner.transfer(address(this).balance);
        // require(owner.send(address(this).balance));
    }
}
