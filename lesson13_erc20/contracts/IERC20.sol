// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IERC20{
    // Return the name of token
    function name() external view returns(string memory);

    // The short name of token(Btc,bnb)
    function symbol() external view returns(string memory);

    // Returns the number of characters after the decimal point
    function decimals() external view returns(uint);

    // Standart functions
    // Return the total number of tokens in circulation
    function totalSupply() external view returns(uint);

    // Return numbers of tokens on accaunt
    function balanceOf(address accaunt)  external view returns(uint);

    function transfer(address to, uint amount) external;

    // Нужно чтобы владелец своего кошелька позволил другому адресу забрать какое то количество токенов в ползу 3-го лица
    function allowance(address _owner,address spender) external view returns(uint);
    
    // Function to confirm the withdrawal of tokens
    function approve(address spender, uint amount) external;

    function transferFrom(address sender, address recipientm, uint amount) external;

    // we can indexing before 2 fields in event, the index allows search by this fields in ethers.js 
    event Transfer(address indexed from,address indexed to, uint amount);

    event Approve(address indexed owner, address indexed to, uint amount);



}

