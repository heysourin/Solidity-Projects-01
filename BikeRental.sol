//SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 <=0.9.0;

contract BikeRentalApp{
    address owner;

    constructor(){
        owner = msg.sender;
    }
    //Add yourself sas a Renter
    struct Renter{
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint due;// amt they have to pay
        uint start;
        uint end;
    }

    mapping (address => Renter) public renters;

    function addRenter(address payable _walletAddrerss, string memory _firstName, string memory _lastName, bool _carRent, bool _active, uint _balance, uint _due, uint _start, uint _end) public{
        renters[_walletAddrerss] = Renter(_walletAddrerss, _firstName, _lastName, _carRent, _active, _balance, _due, _start, _end);
    }


    //Checkout bike

    function checkOut(address walletAddress) public{
        renters[walletAddress].active = true;
        renters[walletAddress].start = block.timestamp;
        renters[walletAddress].canRent = false;
    }
    //Check in abike
    function chcekIn(address walletAddress) public{
        renters[walletAddress].active = false;
        renters[walletAddress].end = block.timestamp;
        setDue(walletAddress);
    }


    //total duration of use
    function renterTimespan(uint start, uint end) internal pure returns(uint){
        return end-start;
    }

    function getTotalDuration(address walletAddress) public view returns(uint){
        uint timespan = renterTimespan(renters[walletAddress].start, renters[walletAddress].end);
        uint timespanInMinutes = timespan / 60;
        return timespanInMinutes;
    }


    //contract balance, notice: not the balance of any particular wallet
    function balanceOf() public view returns(uint){
        return address(this).balance;
    }

    //get rrenter's balance
    function balanceOfRenter(address walletAddress) public view returns(uint){

        return renters[walletAddress].balance;
    }

    //set due amount
    function setDue(address walletAddress) internal{
        uint timespanMinutes = getTotalDuration(walletAddress);
        uint fiveMinuteIncrements = timespanMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 5000000000000000;
    }

    function canRentBike(address walletAddress) public view returns(bool) {
        return renters[walletAddress].canRent;
    }

        // Deposit
    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }

    // Make Payment
    function makePayment(address walletAddress) payable public {
        require(renters[walletAddress].due > 0, "You do not have anything due at this time.");
        require(renters[walletAddress].balance > msg.value, "You do not have enough funds to cover payment. Please make a deposit.");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].start = 0;
        renters[walletAddress].end = 0;
    }
}
