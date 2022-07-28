//Holiday villa booking smart contract

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract HolidayVilla{
    address payable public owner;

    enum StateOfVilla{
        Vacant,
        Booked
    }
    StateOfVilla public sv1;// checked villa's booking status

    constructor(){
        owner = payable(msg.sender);// this will make deployer 'owner', who will receive the money 
        sv1=StateOfVilla.Vacant;//Setting default value vacant
    }

    function book() public payable {
        require(sv1==StateOfVilla.Vacant, "Currently Ocuupied");
        require(msg.value>= 2, "Not enough ether provided");//setting Villa booking price 2 ethers
        owner.transfer(msg.value);// transfering money to 'owner' from other account
        sv1=StateOfVilla.Booked;
    }
}
