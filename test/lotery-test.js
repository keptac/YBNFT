/* eslint-disable no-undef */
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Lotery", function () {
  let Investor, investor, owner;

  beforeEach(async () => {
    Investor = await ethers.getContractFactory("Investor");
    investor = await Investor.deploy();
    [owner, _] = await ethers.getSigners();
  });

  describe("Deployment", () => {
    it("Should set the right owner", async () => {
      expect(await investor.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of investors to the owner", async () => {
      const ownerBalance = await investor.balanceOf(owner.address);
      expect(await investor.totalSupply()).to.equal(ownerBalance);
    });
  });
});
