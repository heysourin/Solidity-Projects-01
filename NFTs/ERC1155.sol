// SPDX-License-Identifier: Unlicensed
pragma solidity 0.8.11;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol"; //tracks how many NFTs have been minted so far
import "@openzeppelin/contracts/utils/Strings.sol"; // convert numbers into strings
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";// will add release function. also notice constructor

contract MyToken is ERC1155, Ownable, Pausable, ERC1155Supply, PaymentSplitter {
    uint256 public publicPrice = 0.015 ether;
    uint256 public allowListPrice = 0.01 ether;
    uint256 public maxSupply = 20;
    uint256 public maxPerWallet = 3;

    bool public publicMintOpen = false;
    bool public allowListMintOpen = true;

    mapping(address => bool) public allowList;
    mapping(address => uint256) public purchasesPerWallet;

    constructor(address[] memory _payees, uint256[] memory _shares)
        ERC1155("ipfs://QmddZTMmJ3E8RW6npMESxGY7FNAxGHKpF7Fie1G11vg648/")
        PaymentSplitter(_payees, _shares)
    {}

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function setAllowList(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) {
            allowList[addresses[i]] = true;
        }
    }

    function editMintingAllowance(bool _publicMintOpen, bool _allowListMintOpen)
        external
        onlyOwner
    {
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    // mint for the vip people
    function allowListMint(uint256 id, uint256 amount) public payable {
        require(allowListMintOpen, "Allow list minting is closed");
        require(allowList[msg.sender], "You are not in the allow list");
        require(msg.value >= allowListPrice * amount, "Pay the correct price");
        mint(id, amount);
    }

    function publicMint(uint256 id, uint256 amount) public payable {
        require(publicMintOpen, "Public mint is not open right now");

        require(msg.value >= publicPrice * amount);
        mint(id, amount);
    }

    function mint(uint256 id, uint256 amount) internal {
        require(
            purchasesPerWallet[msg.sender] <= maxPerWallet,
            "Minting only 3 NFTs per wallet allowed"
        );
        require(id < 2, "You are trying to make wrong token Id"); //we want tokenId only 0 and 1
        require(
            totalSupply(id) + amount <= maxSupply,
            "Sorry! we have minted out"
        );
        _mint(msg.sender, id, amount, "");
        purchasesPerWallet[msg.sender] += amount;
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) whenNotPaused {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function uri(uint256 _id) public view override returns (string memory) {
        require(exists(_id), "URI doesnot exist");
        return
            string(
                abi.encodePacked(super.uri(_id), Strings.toString(_id), ".json")
            );
    }

    function withdraw(address _adrs) external payable onlyOwner {
        uint256 balance = address(this).balance;
        payable(_adrs).transfer(balance);
    }
}
/**
 * @title Ultimate ERC1155 Smart Contract
 *
 * Create Mint function
 * Create Payment Requirement
 * Create supply limit in the mint function
 * Create allwolist functionality: VIP pass or giving special treatments
 * Create withdraw function: withdraw the money from the contract
 * Create payment splitter: Payments splitting for Devs, founders etc
 * Testing on OpenSea
 *
 * @dev How is it different with erc721?
 * erc1155 can have multiple owner
 */
