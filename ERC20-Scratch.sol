//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
abstract contract ERC20_STD{
    function name() public view virtual returns (string memory);
    function symbol() public view  virtual returns (string memory);
    function decimals() public view virtual  returns (uint8);
    function totalSupply() public view virtual returns (uint256);
    
    function balanceOf(address _owner) public view virtual returns (uint256 balance);
    function transfer(address _to, uint256 _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) public virtual  returns (bool success);
    function approve(address _spender, uint256 _value) public virtual  returns (bool success);
    function allowance(address _owner, address _spender) public view virtual  returns (uint256 remaining);


    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract Onwership{

    address public contractOwner;//the one who is gonna deploy
    address public newOwner; //To whom ownership will be handed oved

    event TransferOwnership(address indexed contractOwner, address indexed newOwner);
    constructor(){
        contractOwner = msg.sender;
    }

    function changeOwnership(address _to) public {
        require(contractOwner == msg.sender, "Only contract owner can transfer the ownership");
        newOwner = _to;//setting input address as the new owner
        contractOwner = newOwner; //handing over ownerhsip to new owner
        // newOwner = address(0);
        emit TransferOwnership(msg.sender, _to);
    }

    // function acceptOwner() public {
    //     require(msg.sender == newOwner, "Only new assigned onwer can call it");
    //     contractOwner = newOwner;
    // }
}

contract MyToken is ERC20_STD, Onwership{

    string private _name;
    string private _symbol;
    uint8 public _decimals;
    uint private _totalSupply;

    address public _minter;

    mapping(address => uint) public tokenBalance;
    mapping(address => mapping (address => uint)) public allowedAmount;

    constructor(address minter_){
        _name = 'XENON';
        _symbol = 'XNN';
        _totalSupply = 10000000;
        // _decimals =18;
        _minter = minter_;

        tokenBalance[_minter] = _totalSupply;

    }

    function name() public view override returns (string memory){
        return _name;
    }

    function symbol() public view override returns (string memory){
        return _symbol;
    }

    function decimals() public view override  returns (uint8){
        return _decimals;
    }

    function totalSupply() public view override returns (uint256){
        return _totalSupply;
    }


    
    function balanceOf(address _owner) public view override  returns (uint256 balance){
        return tokenBalance[_owner]; // from the mapping
    }

    function transfer(address _to, uint256 _value) public override returns (bool success){
        require(tokenBalance[msg.sender] >= _value, 'Insufficient balance');
        tokenBalance[msg.sender] -= _value;
        tokenBalance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;// ***
    }

//***** 'transferFrom' function works after 'approve' function *****


    function transferFrom(address _from, address _to, uint256 _value) public override  returns (bool success){
        uint allowedBal = allowedAmount[_from][msg.sender];

        require(allowedBal >= _value, 'That much amount is not allowed');
        tokenBalance[_from] -= _value;
        tokenBalance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }


    function approve(address _spender, uint256 _value) public override  returns (bool success){
        //** we need a mapping of allow
        require(tokenBalance[msg.sender] >= _value);
        allowedAmount[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return allowedAmount[_owner][_spender];
    }

}
