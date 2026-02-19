// test/Web3bridge.test.js
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Web3bridge", function () {
    let contract;
    let owner;
    let user1;
    let user2;
    
    beforeEach(async function () {
        [owner, user1, user2] = await ethers.getSigners();
        
        const Contract = await ethers.getContractFactory("Web3bridge");
        contract = await Contract.deploy();
        await contract.waitForDeployment();
    });
    
    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            expect(await contract.owner()).to.equal(owner.address);
        });
        
        it("Should start with zero operations", async function () {
            expect(await contract.totalOperations()).to.equal(0);
        });
    });
    
    describe("Record Creation", function () {
        it("Should create a record", async function () {
            const data = ethers.toUtf8Bytes("test data");
            
            const tx = await contract.connect(user1).createRecord(data);
            const receipt = await tx.wait();
            
            // Find RecordCreated event
            const event = receipt.logs.find(
                log => log.fragment && log.fragment.name === "RecordCreated"
            );
            expect(event).to.not.be.undefined;
            
            expect(await contract.totalOperations()).to.equal(1);
            expect(await contract.userOperations(user1.address)).to.equal(1);
        });
        
        it("Should reject empty data", async function () {
            await expect(
                contract.connect(user1).createRecord("0x")
            ).to.be.revertedWithCustomError(contract, "InvalidInput");
        });
    });
    
    describe("Batch Operations", function () {
        it("Should batch create records", async function () {
            const dataArray = [
                ethers.toUtf8Bytes("data1"),
                ethers.toUtf8Bytes("data2"),
                ethers.toUtf8Bytes("data3")
            ];
            
            await contract.connect(user1).batchCreateRecords(dataArray);
            
            expect(await contract.totalOperations()).to.equal(3);
            expect(await contract.userOperations(user1.address)).to.equal(3);
        });
    });
    
    describe("Access Control", function () {
        it("Should allow owner to pause", async function () {
            await contract.pause();
            expect(await contract.paused()).to.equal(true);
        });
        
        it("Should prevent non-owner from pausing", async function () {
            await expect(
                contract.connect(user1).pause()
            ).to.be.revertedWithCustomError(contract, "OwnableUnauthorizedAccount");
        });
    });
});
