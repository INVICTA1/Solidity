const { expect } = require("chai")
const { ethers } = require("hardhat")

describe("Payments", function() {
    let acc1
    let acc2
    let payments
        // Этот блок выполняется перед каждым тестом It
    beforeEach(async function() {
        [acc1, acc2] = await ethers.getSigners()
        const Payments = await ethers.getContractFactory("Payments", acc1)
        payments = await Payments.deploy() // Отправляем транзакцию
        await payments.deployed() // Ждем пока тр-ция будет выполнены
        console.log(payments.address)
    })

    it("should be deployed", async function() {
        expect(payments.address).to.be.properAddress
        console.log(payments.balance)
    })

    it("should have 0 ether by default", async function() {
        const balance = await payments.currentBalance()
        expect(balance).to.eq(0)
        console.log(balance)
    })
    it("should be possible to send funds", async function() {
        const sum = 100
        const msg = "Test"

        // const tx = payments.pay("Test", { value: 100 }) //Send tokens from accaunt(default)
        const tx = payments.connect(acc2).pay(msg, { value: sum }) // Send tokens from accaunt 2

        await expect(() => tx).to.changeEtherBalance(acc2, -sum)
            // await expect(() => tx2).to.changeEtherBalance(acc2, -100)

        await expect(() => tx)
            .to.changeEtherBalances([acc2, payments], [-sum, sum])

        // await tx.wait()

        const balance = await payments.currentBalance()

        const newPayment = await payments.getPayment(acc2.address, 0)
        console.log(newPayment)
        expect(newPayment.message).to.eq(msg)
        expect(newPayment.amount).to.eq(sum)
        expect(newPayment.from).to.eq(acc2.address)
    })

    it("")

})