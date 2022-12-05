//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//Importing erc20
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract Crowdfund {

    event Launch(
        uint256 id,
        address indexed creator,
        uint256 goal,
        uint256 startAt,
        uint256 endAt
    );
    event Cancel(uint256 id);
    event Pledge(uint256 indexed id, address indexed caller, uint256 amount);
    event Unpedge(uint256 indexed id, address indexed caller, uint256 amount);
    event Claim(uint256 id);
    event Refund(uint256 id, address indexed caller, uint256 amount);

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint256 startAt;
        uint256 endAt;
        bool claimed;
    }

    IERC20 public immutable token;

    uint256 public count; // Everytime you create a campaign, it increases ie. 'campaign Id'

    mapping(uint256 => Campaign) public campaigns;

    mapping(uint256 => mapping(address => uint256)) public pledgeAmount; // pledgeAmout[id][address] = amount. Will help to chcek how much 
    //amounts of tokens each user has pledged to the campaign

    //Deployed address of your ERC20 token is required.
    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(
        uint256 _goal,
        uint256 _startAt,
        uint256 _endAt
    ) external {
        require(_startAt >= block.timestamp, "Should have started earlier");
        require(_endAt >= _startAt, "Ending should be after the start");
        require(
            _endAt <= block.timestamp + 90 days,
            "End at should be max duration"
        );

        count += 1;
        campaigns[count] = Campaign(
            msg.sender,
            _goal,
            0,
            _startAt,
            _endAt,
            false
        );

        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
    }

    function cancel(uint _id) external{
        Campaign memory campaign = campaigns[_id];
        require(campaign.creator == msg.sender, "Only creator can cancel");
        require(block.timestamp < campaign.startAt,"Already started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external{
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "Not started yet");
        require(block.timestamp <= campaign.endAt, "Already ended");

        campaign.pledged += _amount;
        pledgeAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp <= campaign.endAt, "Already ended");

        campaign.pledged -= _amount;
        pledgeAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpedge(_id, msg.sender, _amount);
    }

    function claim(uint _id) external{
        Campaign storage campaign = campaigns[_id];

        require(msg.sender == campaign.creator, "You are not campaign creator");
        require(block.timestamp > campaign.endAt, "Not ended");
        require(campaign.pledged >= campaign.goal, "Pledged amount is less than goal");
        require(campaign.claimed = false, "Already claimed");

        campaign.claimed = true;

        token.transfer(campaign.creator, campaign.pledged);

        emit Claim(_id);
    }

//If the campaign was unseccessful then refund is available. Like pledge < goal. Then users will be able to take the tokens out of the campaign.
    function refund(uint _id) external{
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt,"Campaign is not ended yet");
        require(campaign.pledged< campaign.goal, "Pledge is more or equal to goal amount");

        uint bal = pledgeAmount[_id][msg.sender];
        pledgeAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}
