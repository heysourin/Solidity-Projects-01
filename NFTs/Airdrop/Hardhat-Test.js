const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lock", function () {
  let owner, user1, user2, user3;
  let nftContract;
  let airdropContract;
  beforeEach(async () => {
    [owner, user1, user2, user3] = await ethers.getsigners();

    const NFTContract = await ethers.getContractFactory("PixelNFTs");
    nftContract = await NFTContract.deploy();

    const AIRDropContract = await ethers.getContractFactory("NFTAirdrop");
    airdropContract = await AIRDropContract.deploy()
  });
});
