const {expect} = require('chai')
const {ethers} = require('hardhat')

describe("Demo", function () {
    let owner
    let other_addr
    let demo
})

beforeEach(async function () {
    [owner, other_addr] = await ethers.getSigners()

    const DemoContract = await ethers.getContractFactory("Demo", owner)//Разворачивание смарт котракта
    demo = await DemoContract.deploy()
    await demo.deployed()
})

async function sendMoney(sender) {
    const amount = 100
    const txData = {
        to: demo.address,
        value: amount
    }
    const tx = await sender.sendTransaction(txData)
    await tx.wait();
    return [tx, amount]
}

it("Should allow to send money", async function () {
    const [sendMoneyTx, amount] = await sendMoney(other_addr)
    // console.log(sendMoneyTx)
    await expect(() => sendMoneyTx).to.changeEtherBalance(demo, amount);//Checking the amount of money
    const timestamp = (
        await ethers.provider.getBlock(sendMoneyTx.blockNumber)
        //Для проверки времени вытягиваем из блокчейна блок где храниться инф-ция о сделке
    ).timestamp


    await expect(sendMoneyTx)
        .to.emit(demo, 'Paid')//Кто должен породить событие и как оно должно называться
        .withArgs(other_addr.address, amount, timestamp)
})

it("Should allow owner to withdraw funds", async function () {
    const [_, amount] = await sendMoney(other_addr)
    const tx = await demo.withdraw(owner.address)// По умолчанию отправляем от имени владельца
    await expect(() => tx).to.changeEtherBalances([demo, owner], [-amount, amount])

})

it ("Not allow other to withdraw funds", async function(){
    const [_, amount] = await sendMoney(other_addr)
    await expect(
        demo.connect(other_addr).withdraw(other_addr.address)
    ).to.be.revertedWith("You are nota an owner")

})