//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract insuranceContract{
    address public insuranceCompany;

    struct Insurance{
        string name;
        address patientAddress;
        uint amountInsured;
        bool isInsured;
    }

    mapping(address => Insurance) public insurance;
    mapping (address => bool) public hospitalMapping;

    constructor(){
        insuranceCompany = msg.sender;
    }

    function setInsurance(string memory _name, uint _amountInsured, address _patientAddress, address _hospitalAdrs) public{
        require(msg.sender == insuranceCompany, "Only owner has the access");
        insurance[_patientAddress] = Insurance(_name, _patientAddress, _amountInsured, true);
        hospitalMapping[_hospitalAdrs]=true;
    }

    function claimInsurance(uint _amt, address _patientAdrs) public{
        require( msg.sender == insuranceCompany ||  hospitalMapping[msg.sender],"Only hospital or the insurance company can claim");
        insurance[_patientAdrs].amountInsured -= _amt;
    }

}
