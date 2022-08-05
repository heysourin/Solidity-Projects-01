//Balance: acc1--> contract --> acc2

// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Wallet {

    address payable public owner;

//you can also make another ac owner, simply by taking input in constructor
    constructor(){
        owner = payable(msg.sender);
    }

//deposit ( ) - To deposit ether to contract balance.
    function deposit() payable public{
    }

    function sendEther(address payable _to, uint _amt)  public payable{
        require(msg.sender == owner, "sender is not allowed");
        _to.transfer(_amt);
    }

    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

}
