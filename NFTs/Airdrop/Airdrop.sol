// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTAirdrop {
    function bulkAirdropNFT(
        IERC721 _erc721ContractAddress,
        address[] calldata _to,
        uint256[] calldata _id
    ) public {
        require(
            _to.length == _id.length,
            "Token ID's don't match the number of receivers"
        );
        for (uint256 i = 0; i < _to.length; i++) {
            _erc721ContractAddress.safeTransferFrom(msg.sender, _to[i], _id[i]);
        }
    }
}
