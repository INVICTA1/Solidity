// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Demo{
    // Func for checking conditions
    // require
    // revert
    // assert
    address owner;
    address demoAdress;// By default 0x00000...
    
    constructor(){// this func is called once when creating a contract
        owner = msg.sender;
    }
    event Paid(address indexed _from, uint _amount, uint _timestamp);
    // Indexed field - we can serach by indexed field, up to 3 fields can be indexed in one event

    function pay() public payable{
        emit Paid(msg.sender,msg.value,block.timestamp);//It is recorded in the event log, not in the blockchain, it is cheaper
        //  Записывается в журнал событий, не в блокчейн, стоит дешевле
        // МОжно читать извне журнал собыйти(фронт) и уведомлять что пришел платеж, внутри контракта нелбзя читать журнал событий
    }

    modifier onlyOwner(address _to){
        require(msg.sender!= owner,"You are nota an owner");
        require(msg.sender!=address(0),"It 0 address");
        _;// Go out from modifier and perform the func
        // reuire(...) - This is done after calling body of func
    }

    function withdraw(address payable _to) external onlyOwner(_to){
        // onlyOwner - This as called first, then body of func

        // require(msg.sender==owner,"You are not an owner");// If else construction

        // if (msg.sender!=owner){
        //     revert("You are not an owner");// This func is always called, (else)
        // }

        // assert(msg.sender != owner);// Panic func
        _to.transfer(address(this).balance);// any men can called this func
    }

    //Test

    receive() external payable{
        pay();
    }
    
}