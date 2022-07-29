//Winner will be random

//deployer will be manager, will pick winner can't participate himself
//and transfer all the winning price and will reset the code
 
//another sate variable will be players in  array
//participants have to pay minimum amt to participate
//one participant can enter only once

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

contract Lottery{

    address public manager;
    address payable[] public players;

    constructor(){
        manager=msg.sender;
    }

    function alreadyEntered() public view returns(bool){
        for(uint i=0;i<players.length;i++){
            if(players[i]==msg.sender)
                return true;
        }
        return false;
    }

    function enter() public payable {
        require(msg.sender!=manager, "Manager Can't Participate");
        require(alreadyEntered()==false,"Player already entered");
        require(msg.value>=1 ether, "Minimum amount must be paid");
        players.push(payable(msg.sender));
    }

    function random() private view returns(uint){
       return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));
    }
    
    function pickWinner() public{
        require(msg.sender== manager,"Only manager can pick the winner");
        uint indx=random()%(players.length);//winner index
        address contractAddress = address(this);
        players[indx].transfer(contractAddress.balance);
        players = new address payable[](0);//reset
    }

    function getPlayers() public view returns(address payable[] memory){
        return players;
    }
}
