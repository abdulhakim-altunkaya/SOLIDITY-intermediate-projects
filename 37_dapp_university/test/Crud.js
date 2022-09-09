const { expect } = require("chai");
const { ethers } = require("hardhat");
const { time, loadFixture } = require("@nomicfoundation/hardhat-network-helpers");


describe("deployment", () => {



  async function deployContract() {
    const Crud = await ethers.getContractFactory("Crud");
    const crud = await Crud.deploy();
    return {crud};
  }

  it("constructor should assign values", async () => {
    const { crud } = await loadFixture(deployContract);
    expect(await crud.name()).to.equal("bla bla")
  });
})
