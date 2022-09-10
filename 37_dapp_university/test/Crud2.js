const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("deployment simple", () => {
  it("constructor should assign values", async () => {
    const Crud = await ethers.getContractFactory("Crud");
    const crud = await Crud.deploy();
    expect(await crud.name()).to.equal("bla bla");
  });
});