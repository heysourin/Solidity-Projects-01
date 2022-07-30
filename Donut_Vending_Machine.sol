//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract VendingMachine{
    address public owner;  //setting owner
    mapping(address => uint) public donutNumbers;
    
    constructor(){
        owner = msg.sender;//msg: gloobal variable, sender is a property of it
        donutNumbers[address(this)] = 100; //address of the deployed contract,not of wallet
    }

    function getdonutNumber() public view returns(uint){
        return donutNumbers[address(this)];
    }

    function purchase(uint amount) public payable{
        require(msg.value >= amount * 2 ether, "Must pay atleast 2 ethers per donut");
        require(msg.sender != owner, "Owner can't buy");//owner allow deployer account to buy donuts
        require(donutNumbers[address(this)] >= amount, "Not enough dounuts availble");//must have more donuts than the order
        donutNumbers[address(this)] -= amount;
        donutNumbers[msg.sender] += amount;
    }

    function restock(uint amount) public {
        require(msg.sender == owner, "Only owner can restock the machine");
        donutNumbers[address(this)] += amount;
    }
}
