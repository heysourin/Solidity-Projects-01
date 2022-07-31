// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";

contract BuyMeACoffee{
   //Event to emit memo
    event NewMemo(address indexed from, uint timeStamp, string name, string message);

   //memo struct
   struct Memo{
        address from;
        uint timeStamp;
        string name;
        string message;
   }

   Memo[] memos;   //lists of memos received

   address payable owner;//this is where we are going to receive the tips

    constructor(){
        owner = payable(msg.sender);

    }      
/*  * @dev buy a coffee for owner (sends an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
*/
   
    function buyCoffee(string memory _name, string memory _message) public payable{
        require(msg.value > 0, "Can't buy coffee with 0");

        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    } 


/*  * @dev send the entire balance to the owner
*/
    function withDrawTips() public{
        //address(this).balance//balance stored in the blockchain
        require(owner.send(address(this).balance));
    }

/*  * @dev retrive all the memos received and stored on the blockchain
*/
    function getMemo() public view returns(Memo[] memory){
        return memos;
    }
}
