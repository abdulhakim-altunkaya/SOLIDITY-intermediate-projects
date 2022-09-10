const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("deployment", () => {

  async function deployContract() {
    const Crud = await ethers.getContractFactory("Crud");
    const crud = await Crud.deploy();
    return {crud};
  }

  it("should return string value of name variable assigned by Constructor", async () => {
    const { crud } = await loadFixture(deployContract);
    expect(await crud.name()).to.equal("bla bla")
  });
  it("should return uint value of count variable assigned by Constructor", async () => {
    const { crud } = await loadFixture(deployContract);
    expect(await crud.count()).to.equal(2);
  });
  it("should check if functions are working", async () => {
    const { crud } = await loadFixture(deployContract);
    await crud.increment(5);
    expect(await crud.number2()).to.equal(5);
  })

})
