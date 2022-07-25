const hre = require("hardhat");
const ethers = hre.ethers
const TransfersArtifact = require('../artifacts/contracts/Transfers.sol/Transfers.json') // Нужно для правильного вызова функций из контракта


async function currentBalance(address, message = '') {
    const rawBalance = await ethers.provider.getBalance(address) // Provider - объект  с помощъю которго мы подключаемся к блокчейну и отправляем транзакции
    console.log(message, ethers.utils.formatEther(rawBalance))
}

async function getTransfer(transfersContract, index) {
    const result = await transfersContract.getTransfer(index);
    console.log(ethers.utils.formatEther(result['amount']), result['sender'])
}


async function main() {
    const [acc1, acc2] = await ethers.getSigners()
    const contractAddress = '0x5FbDB2315678afecb367f032d93F642f64180aa3'
    const transfersContract = new ethers.Contract( // инстанцируем объект нашего контракта
        contractAddress, TransfersArtifact.abi, acc1) // Относительно этого объекта можем вызывать функции которые прописаны в смарт контракте
    await getTransfer(transfersContract, 0)


    // Перебрасываем деньги с 2-го акк на смарт контрак,(больше 3 переводов запрещено, установлено в deploy.js)
    const tx = {// Создаем тр-цию
        to: contractAddress,//адресс
        value: ethers.utils.parseEther('1')// Количество переданных денег
    }

    // const txSend = await acc2.sendTransaction(tx)// Переводим деньги
    // await txSend.wait()
    //
    // const b1 = ethers.utils.formatEther(await acc2.getBalance())// Запросить баланс на 2-й акк
    // console.log(b1)
    const result = await transfersContract.withdrawTo(acc2.address)
    console.log(result)
    // Смотрим баланс
    await currentBalance(contractAddress, 'Contract Balance')
    await currentBalance(acc2.address, 'Acc2 Balance')

    // const result = await transfersContract.connect(acc2).withdrawTo(acc2.address)
    // Попытка перевести с другого адреса деньги, не владельца
    // console.log(result)


}


main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});