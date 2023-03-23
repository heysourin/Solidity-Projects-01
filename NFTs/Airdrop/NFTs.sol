// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.3/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.3/utils/Counters.sol";

contract TimelessChild is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("AirdropBySourin", "AS") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmcFDx8avDtPXWzTFrJbdRd8m7aBJsdV95VsCum8i17qZH";
    }

    function safeMint() public {
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
    }

    function bulkMint(uint16 amount) public {
        for(uint16 i = 0; i < amount; i++) {
            safeMint();
        }
    }
    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        pure
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return string(abi.encodePacked(_baseURI(), "/", Strings.toString(tokenId)));
    }
}
//REMINDER: Before you mint from Airdrop contract, you have to approve the airdrop contract
