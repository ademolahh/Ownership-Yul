const { expect } = require("chai");
const { ethers, deployments } = require("hardhat");

describe("test", () => {
  let test, owner, newOwner;
  beforeEach(async () => {
    const accounts = await ethers.getSigners();
    [owner, newOwner] = accounts;
    await deployments.fixture(["all"]);
    test = await ethers.getContract("Test");
  });
  it("ownership", async () => {
    expect(await test.owner()).to.equal(owner.address);
  });
  it("transfer ownership", async () => {
    await expect(test.connect(newOwner).transferOwnership(newOwner.address)).to
      .be.reverted;
    await expect(test.transferOwnership(ethers.constants.AddressZero)).to.be
      .reverted;
    await test.connect(owner).transferOwnership(newOwner.address);
    expect(await test.owner()).to.equal(newOwner.address);
  });
  it("renouce ownership", async () => {
    await test.renounceOwnership();
    expect(await test.owner()).to.equal(ethers.constants.AddressZero);
  });
  it("increase count", async () => {
    await expect(test.connect(newOwner).increaseCount()).to.be.reverted;
    await test.increaseCount();
    expect(await test.getNumber()).to.be.equal("1");
  });
});
