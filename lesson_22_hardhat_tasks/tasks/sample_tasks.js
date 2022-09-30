// require("@nomicfoundation/hardhat-toolbox");
// require('hardhat/config')

task("balance", "Displays balance( description)")
    .addParam('account', 'Account address')//require param
    .addOptionalParam('greeting', 'Greeting to print', 'Default greeting', types.string)
    .setAction(async (taskArgs, hre) => {

        const account = taskArgs.account;
        const msg = taskArgs.greeting;

        console.log(msg);
        const balance = await hre.ethers.provider.getBalance(account);
        console.log(balance.toString());
    })

task("callme", "Call demo func")
    .addParam('contract', 'Contract address')//require param
    .addOptionalParam('account', 'Account', "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", types.string)
    .setAction(async (taskArgs ) => {
        console.log(taskArgs.contract)
        console.log(taskArgs.account)
    })

task("pay", "Call pay func")
    .addParam('value', 'Value to send', 0, types.int)//require param
    .addOptionalParam('account', 'Account', "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266", types.string)
    .setAction(async (taskArgs, {ethers}) => {
        const account = taskArgs.account;
        const MyContract = await ethers.getContractFactory("Demo");
        const demo = await MyContract.attach(
            '0x5FbDB2315678afecb367f032d93F642f64180aa3'
        );
        // const demo = await ethers.getContract("Demo");
        const tx = await demo.pay(`Hello ${account}`, {value: taskArgs.value});
        await tx.wait();

        // console.log(await demo.message())
        const balance = await ethers.provider.getBalance(demo.address);
        console.log(await balance.toString())

        console.log('0x5FbDB2315678afecb367f032d93F642f64180aa3', await ethers.provider.getBalance('0x5FbDB2315678afecb367f032d93F642f64180aa3'))
    })

task('distribute', "Call distribute func")
    .addParam('addresses', "Addresses to distribute to")
    .setAction(async (taskArgs, hre) => {
            const demo1 = await hre.ethers.getContractAt( 'Demo','0x5FbDB2315678afecb367f032d93F642f64180aa3')
            const Demo = await hre.ethers.getContractFactory('Demo')
            const demo = Demo.attach('0x5FbDB2315678afecb367f032d93F642f64180aa3')
            console.log('0x5FbDB2315678afecb367f032d93F642f64180aa3', await ethers.provider.getBalance('0x5FbDB2315678afecb367f032d93F642f64180aa3'))
            console.log('Demo', await ethers.provider.getBalance(demo.address))

            const addrs = taskArgs.addresses.split(',');
            const tx = await demo.distribute(addrs);
            await tx.wait();
            console.log('Demo',demo.address)
            const tx1 = await demo.message();
            console.log('demo.getBalance',await tx1.wait());

            await Promise.all(addrs.map(async (addr) => {
                    console.log((await ethers.provider.getBalance(addr)).toString())
                }
            ))
            console.log('0x5FbDB2315678afecb367f032d93F642f64180aa3', await ethers.provider.getBalance('0x5FbDB2315678afecb367f032d93F642f64180aa3'))
            console.log('Demo', await ethers.provider.getBalance(demo.address))

        }
    )