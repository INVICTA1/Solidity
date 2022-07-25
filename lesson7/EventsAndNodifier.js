const { expect } = require('chai')
const { ethers } = require('hardhat')

describe("Demo", function() {
    let owner
    let other_addr
    let demo
})

beforeEach(async function() {
    [owner, other_addr] = await ethers.getSigners()

    const DemoContract = await ethers.getContractFactory("Demo", owner)
    demo = await DemoContract.deploy()
    await demo.deployed()
})

async function getMoney

it("Should allow to send money", async function() {

})