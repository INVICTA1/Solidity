const {expect} = require('chai')
const {ethers} = require("hardhat")

describe("LibDemo", function () {
    let owner
    let demo

    beforeEach(async function () {
        [owner] = await ethers.getSigners()
        const LibDemo = await ethers.getContractFactory('LibDemo', owner)
        demo = await LibDemo.deploy()
        await demo.deployed()
    })

    it('compares strings', async function () {
        const result = await demo.runStr('cat', 'cat')
        expect(result).to.eq(true)

        const result2 = await demo.runStr('cat', 'dog')
        expect(result2).to.eq(false)
    })

    it('should finds el in array ', async function () {
        const result3 = await demo.runArray([1, 2, 3], 1)
        await expect(result3).to.eq(true)

        const result4 = await demo.runArray([1, 2, 3], 4)
        await expect(result4).to.eq(false)

    });

})