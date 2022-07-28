const {expect} = require('chai')
const {ethers} = require('hardhat')
const {applyWorkaround} = require("hardhat/internal/util/antlr-prototype-pollution-workaround");

describe("AucEngine", function () {
    let owner;
    let seller;
    let buyer;
    let auct;

    beforeEach(async function () {
        [owner, seller, buyer] = await ethers.getSigners()

        const AucEngine = await ethers.getContractFactory('AucEngine', owner)
        auct = await AucEngine.deploy()
        await auct.deployed()
    })

    it('should be owner', async function () {
        const currentOwner = await auct.owner();
        console.log(currentOwner)
        // console.log(owner)
        expect(currentOwner).to.eq(owner.address)

    })

    async function getTimestamp(bn) {
        return (await ethers.provider.getBlock(bn)).timestamp
    }

    describe("createAuction", function () {//local describe
        it("creates auction correctly", async function () {
            const duration = 120
            const tx = await auct.createAuction(ethers.utils.parseEther("0.0001"), 3, "test item", duration)

            const cAuction = await auct.auctions(0);
            // console.log(cAuction)
            expect(cAuction.item).to.eq("test item")

            const ts = await getTimestamp(tx.blockNumber)

            expect(cAuction.endAt).to.eq(ts + duration)
        })
    })

    function delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms))
    }

    describe("buy", function () {
        it("allows to buy", async function () {
            const duration = 120
            const tx = await auct.connect(seller).createAuction(ethers.utils.parseEther("0.0001"), 3, "test item", duration)

            this.timeout(5000)//явно указываем 5 сек(тест работает до 5 сек) Фреймворк Mocka будет ждать, потом тест вылетит
            await delay(1000)// Ждем 1 сек

            const buyTx = await auct.connect(buyer).buy(0, {value: ethers.utils.parseEther("0.0001")})
            const cAuction = await auct.auctions(0);
            const finalPrice = cAuction.finalPrice
            await expect(() => buyTx).to.changeEtherBalance(seller, finalPrice - Math.floor((finalPrice * 10) / 100))

            await expect(buyTx)
                .to.emit(auct, 'AuctionEnded')
                .withArgs(0, finalPrice, buyer.address)

            await expect(
                auct.connect(buyer).buy(0, {value: ethers.utils.parseEther("0.0001")})
            ).to.be.revertedWith('Stopped')

        })
    })
})