// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract dNFT is ERC721Enumerable, Ownable {
    using Strings for uint256;//It will be used to make tokenId -> string in later part

    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public const = 10 ether;
    uint256 public maxSupply = 1000;
    uint256 public maxMintAmount = 2;
    uint256 public nftPerAddressLimit = 2;
    bool public paused = false;
    bool public revealed = false;

    mapping(address => uint256) public addressMintedBalance; //For checking how many nfts has been mintes from one wallet

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseUri,
        string memory _initNotRevealedUri
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseUri);
        setNotRevealedURI(_initNotRevealedUri);
    }

    //internal function to get baseURI, calling and overriding from erc721enumerable
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    //Function for minting NFT
    function mint(uint256 _mintAmount) public payable {
        require(!paused, "The contract is paused");

        uint256 supply = totalSupply(); // Calling a function fromm ERC721Enumerable
        require(_mintAmount > 0, "Need to mint atleast one nft");
        require(_mintAmount <= maxMintAmount, "Has hit max limit per session");
        require(supply + _mintAmount <= maxSupply, "Maximum limit exceeded");

        // WHITELISTED LOOPO TO BE ADDED HERE

        //Minting and putting nft to onwer
        for (uint256 i = 1; i < _mintAmount; i++) {
            addressMintedBalance[msg.sender]++; //Number of nfts minted for msg.sender is increased by one

            _safeMint(msg.sender, supply + i);
        }
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner); ///function from erc721enumerable
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i = 0; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId), //accessing function from erc721enumerable
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    function reveal() public onlyOwner {
        revealed = true;
    }

    function setNftPerAdfdressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        const = _newCost;
    }

    function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
        maxMintAmount = _newMaxMintAmount;
    }

    function setBaseURI(string memory _newbaseURI) public onlyOwner {
        baseURI = _newbaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setNotRevealedURI(string memory _newNotRevealedURI)
        public
        onlyOwner
    {
        notRevealedUri = _newNotRevealedURI;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }
}
