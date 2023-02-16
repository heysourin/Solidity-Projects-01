// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MyERC20 is ERC20, Ownable, ERC721Holder {
    // address public nft;
    IERC721 public nft;
    mapping(uint256 => address) public tokenOwnerOf;
    mapping(uint256 => uint256) public tokenStakedAt;
    uint256 public EMMISION_RATE = ((50 * 10) ^ decimals()) / 1 days;

    constructor(address _nft) ERC20("MyERC20", "M20") {
        nft = IERC721(_nft);//wrapping in ierc721 allows to interprate nft address as erc721 contract. which will allow us to call 'tranferFrom' etc.
    }

    // function mint(address to, uint256 amount) public onlyOwner {
    //     _mint(to, amount);
    // }

    function stake(uint256 tokenId) external {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwnerOf[tokenId] = msg.sender;
        tokenStakedAt[tokenId] = block.timestamp;
    }

    function calculateTokens(uint256 tokenId) public view returns(uint256){
        uint256 timeElapsed = block.timestamp - tokenStakedAt[tokenId];
        return timeElapsed * EMMISION_RATE;
    }

    function unstake(uint256 tokenId) external {
        require(tokenOwnerOf[tokenId] == msg.sender, "You can't unstake");
        _mint(msg.sender, calculateTokens(tokenId));
        nft.transferFrom(address(this),msg.sender,tokenId);

        delete tokenOwnerOf[tokenId];
        delete tokenStakedAt[tokenId];
    }
}
