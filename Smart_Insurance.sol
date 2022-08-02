//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract SmartInsurance{
    struct Patient{
        string name;
        bool isInsured;
        address patientAddress;
        uint amountInsured;
    }

    mapping(address => Patient) public patientMapping;
    mapping(address => bool) public hospitalMapping;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner has the access");
        _;
    }

    function sethospital(address _hospitalAdrs) public onlyOwner{
        // require(!hospitalMapping[_hospitalAdrs]);
        hospitalMapping[_hospitalAdrs]=true;
    }

    function setPatient(string memory _name, address _patientAdrs, uint _amountInsured) public onlyOwner {
        patientMapping[_patientAdrs] = Patient(_name, true, _patientAdrs, _amountInsured);
    }


/* @dev owner(Insurance company) and only hospital (set by owner) can take out the insurance*/

    function withdrawInsurance(uint _amtClaimed, address _patientadrs) public{
        require(hospitalMapping[msg.sender] || msg.sender==owner,"Not a hospital");
        patientMapping[_patientadrs].amountInsured -= _amtClaimed;
    }
}
