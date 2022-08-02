//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract SmartInsurance{
    struct Patient{
        string name;
        bool isInsured;
        address patientAddress;
        uint amountInsured;
    }

    mapping(address => Patient)  patientMapping;
    mapping(address => bool) hospitalMapping;
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

    function claimInsurance(uint _amtClaimed) public {
        require(hospitalMapping[msg.sender],"Not a hospital");
    }
}
