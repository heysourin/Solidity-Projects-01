const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lock", function () {
  let owner, user1, user2, user3;
  let nftContract;
  let airdropContract;
  beforeEach(async () => {
    [owner, user1, user2, user3] = await ethers.getSigners();

    const NFTContract = await ethers.getContractFactory("PixelNFTs");
    nftContract = await NFTContract.deploy();

    const AIRDropContract = await ethers.getContractFactory("NFTAirdrop");
    airdropContract = await AIRDropContract.deploy();
  });

  describe("It will mint Tokens in the erc721 smart contract", function () {
    it("Should mint a single NFT", async () => {
      await nftContract.safeMint();

      expect(await nftContract.balanceOf(owner.getAddress())).to.equal("1");
    });

    it("Should mint NFTs in bulk", async () => {
      await nftContract.bulkMint(10);

      expect(await nftContract.balanceOf(owner.getAddress())).to.equal("10");
    });
  });

  describe("It will test Airdrop contract", function () {
    it("Should test Airdrop contract and return the correct owner of the NFTs", async () => {
      await nftContract.bulkMint(10);

      await nftContract.setApprovalForAll(airdropContract.address, true);

      const nftContractAddress = await nftContract.address;

      const user1Address = await user1.getAddress();
      const user2Address = await user2.getAddress();
      const user3Address = await user3.getAddress();

      const userArray = [user1Address, user2Address, user3Address];

      const nftIds = ["2", "3", "5"];

      await airdropContract.bulkAirdropNFT(
        nftContractAddress,
        userArray,
        nftIds
      );

      expect(await nftContract.ownerOf(2)).to.equal(user1Address);
      expect(await nftContract.ownerOf(3)).to.equal(user2Address);
      expect(await nftContract.ownerOf(5)).to.equal(user3Address);
    });
  });
});
