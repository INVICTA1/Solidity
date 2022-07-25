// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo{
    // public - can call func inside and outside contract
    // external - only inside contract
    // internal - only outside contract
    // private - only inside contract but can't call decident(child)

    // Function
    // view - can read data in blockchain and return data but don't modifier, this func called by method "call"
    // pure(clean func) -  can't read data from blockchain

    string message  = "hello";
    uint public balance;
    // Transaction - It's cost money,uses for modify data in blockchain, transfer or take money, can't return something
    // Func called by transaction and we have to pay for call
    function setMessage(string memory newMessage) external {
        message = newMessage;
    }

    function pay() external payable{
        // balance += msg.value; - Could don't write this code, this is done automatically
    }
    
    // This func is called when smartcontract recives money but doesn't give information which func should be called
    receive() external payable{

    }
    // This func is called when called func which doesn't exist in smartcontract

    fallback() external payable{

    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function getBalance1() public view returns(uint balance){
        balance = address(this).balance;
    }

    function getMessage() external view returns (string memory ){
        return message;
    }

    function rate(uint amount) public pure returns(uint){
        return amount*3;
    }


}