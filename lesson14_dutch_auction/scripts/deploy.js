// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const ethers = hre.ethers
const fs = require('fs')
const path = require('path')
const {network} = require("hardhat");

async function main() {
    if (network.name === 'hardhat') {
        console.warn("You use hardhat network, use the Hardhat + option '--network localhost' ")
    }
    const [deployer] = ethers.getSigners()
    console.log("Deployer address", deployer.address)
    const DutchAuction = await ethers.getContractFactory('DutchAuction', deployer)
    const auction = await DutchAuction.deploy(
        ethers.utils.parseEther('2.0'),
        1,
        "Motorbike"
    )
    await auction.deployed()

}
async function saveFrontendFiles(contracts){
    const contractsDir = path.join(__dirname,'/..','front/contracts')
    if(!fs.existsSync(contractsDir)){
        fs.mkdir(contractsDir)
    }
}
// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
