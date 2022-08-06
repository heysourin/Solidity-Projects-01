// ERC stands for Ethereum Request for Comments. An ERC is a form of proposal and its purpose
// is to define standards and practices.

// ERC20 is a proposal that intends to standardize howa token contract should be defined, how
// we interact with such a token contract and how these contracts interact with each other.

// ERC20 is a standard interface used for financial applications.

// A full compatible ERC20 Token must implement 6 functions and 2 events.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address tokenOwner) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Block1 is IERC20{
    string public name = "XENON"; //name of our token
    string public symbol = "XNN";

    string public decimal = '0';
    uint public override totalSupply;
    address public founder;
    mapping(address => uint) public balance;
    mapping(address => mapping(address => uint)) public allowed;

    constructor(){
        totalSupply = 100000;
        founder = msg.sender;
        balance[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns(uint){
        return balance[tokenOwner];
    }

    function transfer(address to, uint value) public override returns(bool success){
        require(balance[msg.sender] >= value);
        balance[to] += value;
        balance[msg.sender] -= value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint amount) public override returns(bool success){
        require(balance[msg.sender] >= amount);        
        require(amount > 0);
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint){
        return allowed[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint amount) public override returns (bool){
        require(allowed[sender][recipient] >= amount);
        require(balance[sender] >= amount);
        balance[sender] -= amount;
        balance[recipient] += amount;
        return true;
    }
}
