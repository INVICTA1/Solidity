// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract ComRev {
    address[] public candidates = [
        0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db,
        0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB,
        0x617F2E2fD72FD9D5503197092aC168c91465E7f2
    ];

    mapping(address => bytes32) public commits;
    mapping(address => uint) public votes;
    bool votingStopped;
    address owner;

    constructor(){
        owner = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "not an owner");
        _;
    }
    // front hashing data and send to func
    function commitVote(bytes32 _hashVote) external {
        require(!votingStopped);
        require(commits[msg.sender] == bytes32(0));

        commits[msg.sender] = _hashVote;
    }


    function stopVoting() onlyOwner external {
        require(!votingStopped);
        votingStopped = true;
    }

    function revealVote(address _candidate, bytes32 _secret) external{
        require(votingStopped,"Voting not stopped");
        
        bytes32 commit = keccak256(abi.encodePacked(_candidate, _secret, msg.sender));

        require(commit == commits[msg.sender],"Invalid data");

        delete commits[msg.sender];

        votes[_candidate]++;

    }
}



// commit fase - 

// npx hardhat console

// The secret phrase with which we confirm ourselves
// ethers.utils.formatBytes32String("Secret") - get from string bytes32
// valaue  '0x5365637265740000000000000000000000000000000000000000000000000000'

//ethers.utils.solidityKeccak256(['address', 'bytes32', 'address'], ['0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db','0x5365637265740000000000000000000000000000000000000000000000000000','0x5B38Da6a701c568545dCfcB03FcB875f56beddC4'])
// We get a hash based on these 3 fields
// 0xe68af086cc2689595f79a2a07e4f2f08df7fc210aa87785ee915ccfcc0a53620



// commit reveal - open your voise