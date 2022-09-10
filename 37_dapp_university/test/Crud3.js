const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("deployment with beforeEach", () => {
    let crud;

    beforeEach("deploy contract", async () => {
        const Crud = await ethers.getContractFactory("Crud");
        crud = await Crud.deploy();
    })

    it("should return string value", async () => {
        expect(await crud.name()).to.equal("bla bla");
    })
    it("should return uint value from constructor", async () => {
        expect(await crud.count()).to.equal(2);
    })
    it("should update a var by calling write function", async () => {
        await crud.increment(8);
        let newValue = await crud.number2();
        expect(newValue).to.equal(8);
        await crud.increment(8);
        let newValue2 = await crud.number2();
        expect(newValue2).to.equal(16);
    })

    it("should get the name", async () => {
        let data = await crud.getName();
        expect(data).to.be.reverted("bsla bla");
    })


})

