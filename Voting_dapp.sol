//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "../node_modules/hardhat/console.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Create {
    //This is the way we use plugins in our smart contracts.useing 'contract-name' for 'function-we-want-to-use'
    // make sure you use the same name;
    using Counters for Counters.Counter;

    Counters.Counter public _voterId;
    Counters.Counter public _candidateId;

    address public votingOrganizer;

    //Todo:
    //---- Candidate for the vote ----
    struct Candidate {
        uint candidateId;
        string age;
        string name;
        string image; //From IPFS we are going to add the image
        uint voteCount;
        address _address;
        string ipfs; //IPFS going to contain all the informations about the candidate, we will upload the entire data to the ipfs and fetch and add as an url. Anyone wants to know more about the candidate they can go to the link and learn about the canditate along with all details.7
    }

    event CandidateCreate(
        uint indexed candidateId,
        string age,
        string name,
        string image,
        uint voteCount,
        address _address,
        string ipfs
    );

    address[] public candidateAddress;

    mapping(address => Candidate) public candidates;

    //---End of candidate data---

    // ---- VOTER DATA ----
    address[] public votedVoters;
    address[] public votersAddress;

    struct Voter {
        uint voter_voterId;
        string voter_name;
        string voter_image;
        address voter_address;
        uint voter_allowed;
        bool voter_voted;
        uint voter_vote;
        string voter_ipfs;
    }
    mapping(address => Voter) public voters;

    event VoterCreated(
        uint voter_voterId,
        string voter_name,
        string voter_image,
        address voter_address,
        uint voter_allowed,
        bool voter_voted,
        uint voter_vote,
        string voter_ipfs
    );

    //----End of voter data----

    constructor() {
        votingOrganizer = msg.sender;
    }

    //----Functions starting from here----
    function setCandidate(
        address _address,
        string memory _age,
        string memory _name,
        string memory _image,
        string memory _ipfs
    ) public {
        require(
            votingOrganizer == msg.sender,
            "Only organizer can create candidature"
        );

        _candidateId.increment(); //calling this function from 'counter.sol'

        uint idNumber = _candidateId.current();

        Candidate storage candidate = candidates[_address]; //assigning the mapping using struct

        candidate.age = _age;
        candidate.name = _name;
        candidate.candidateId = idNumber;
        candidate.image = _image;
        candidate.voteCount = 0;
        candidate._address = _address;
        candidate.ipfs = _ipfs;

        candidateAddress.push(_address);

        emit CandidateCreate(
            idNumber,
            _age,
            _name,
            _image,
            candidate.voteCount,
            _address,
            _ipfs
        );
    }

    function getCandidate() public view returns (address[] memory) {
        return candidateAddress;
    }

    function getCandidateLength() public view returns (uint) {
        return candidateAddress.length;
    }

    function getCandidateData(address _address)
        public
        view
        returns (
            string memory,
            string memory,
            uint,
            string memory,
            uint,
            string memory,
            address
        )
    {
        return (
            candidates[_address].age,
            candidates[_address].name,
            candidates[_address].candidateId,
            candidates[_address].image,
            candidates[_address].voteCount,
            candidates[_address].ipfs,
            candidates[_address]._address
        );
    }

    //!'Tuple component can not be empty' means somewhere there is an extra ','

    //----Voter section----
    function voterRight(
        address _address,
        string memory _name,
        string memory _image,
        string memory _ipfs
    ) public {
        require(votingOrganizer == msg.sender, "Only organizer has the access");

        _voterId.increment();

        uint idNumber = _voterId.current();

        Voter storage voter = voters[_address];

        require(voter.voter_allowed == 0, "Already registered");

        voter.voter_allowed = 1;
        voter.voter_name = _name;
        voter.voter_image = _image;
        voter.voter_address = _address;
        voter.voter_voterId = idNumber;
        voter.voter_vote = 1000;
        voter.voter_voted = false;
        voter.voter_ipfs = _ipfs;

        votersAddress.push(_address);

        emit VoterCreated(
            idNumber,
            _name,
            _image,
            _address,
            voter.voter_allowed,
            voter.voter_voted,
            voter.voter_vote,
            _ipfs
        );
    }

    function vote(address _candidateAddress, uint _candidateVoteId) external {
        Voter storage voter = voters[msg.sender];
        require(!voter.voter_voted, "Already Voted");
        require(voter.voter_allowed != 0, "You are not registered to vote");

        voter.voter_voted = true;
        voter.voter_vote = _candidateVoteId;
        votedVoters.push(msg.sender);

        candidates[_candidateAddress].voteCount += voter.voter_allowed;
    }

    function getVoterLength() public view returns (uint) {
        return votersAddress.length;
    }

    function getVoterData(address _address)
        public
        view
        returns (
            uint,
            string memory,
            string memory,
            address,
            string memory,
            uint,
            bool
        )
    {
        return (
            voters[_address].voter_voterId,
            voters[_address].voter_name,
            voters[_address].voter_image,
            voters[_address].voter_address,
            voters[_address].voter_ipfs,
            voters[_address].voter_allowed,
            voters[_address].voter_voted
        );
    }

    //----Data of all of the people voted from the voterlist---
    function getVotedVoterList() public view returns (address[] memory) {
        return votedVoters;
    }

    //----
    function getVoterList() public view returns (address[] memory) {
        return votersAddress;
    }
}
