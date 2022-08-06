//Manager & participants
//participants must be >=3
//random selection
//participants must have wallets
//one can buy more than one lottery, that will make him/her probablity more
//participants will be registered when they transfer ethers
//manager will have full control
//contract will be reset at the end of competition

//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Lottery{
    
    address public manager;
    address payable[] public participants; //therer will be so many participants

    constructor(){
        manager = msg.sender;
    }

//receive() can be called only once and with external visibility
//access receive() with 'calldata & transact' button
    receive() external payable{
        require(msg.value >= 1 ether, "Min 1 ether");
        participants.push(payable(msg.sender));//payable as array hasbeen declared as payable
    }
    
    function getBalance() public view returns(uint){
        require(msg.sender == manager, "Only manager have the access");
        return address(this).balance;
    }

//genarating a random number
    function random() public view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
        //we have to convert keccak algo into uint asa it will give 64 hexadecimal chars
    }

    function selectWinner() public returns(address){
        require(msg.sender == manager, "Only manager selects the winner");
        require(participants.length >= 3, "For atleat 3 participants");

        address payable winner;
        uint index =  random() % (participants.length);// gives remainder, where value is '0 to <divisor'
        winner = participants[index];
        winner.transfer(getBalance());
        participants = new address payable[](0);//reset the lottery
        return winner;
    }
}
