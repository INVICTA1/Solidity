const hre = require("hardhat");
const ethers = hre.ethers

async function main() {
    const [signer] = await ethers.getSigners() // Разворачиваем контракт от имени самого первого аккаутна в hardhat
    const Transfers = await ethers.getContractFactory('Transfers', signer)
    const transfers = await Transfers.deploy(3) // Развертование нашего смарт контракта в blockchain,
    // 3 - передается в конструктор blockchain

    await transfers.deployed() // Ждем разворачивания контракта

    console.log(transfers.address)

    // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
    // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

    // const lockedAmount = hre.ethers.utils.parseEther("1");

    // const Lock = await hre.ethers.getContractFactory("Lock");
    // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

    // await lock.deployed();

    // console.log("Lock with 1 ETH deployed to:", lock.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});