// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Op {
    //Static value

    //    uint demo;//default = 0, gaz = 67066

    //    113512 gaz
    // uint128 a = 1;
    // uint128 b = 1;
    // uint256 c = 1;

    // 89240 gaz
    // uint demo = 1;

    //114791 gaz
    // bytes32 public hash = 0xdeb9eddf97d695c426472b8aae4a60b40e75b9b16fa725eb11fcdad20fa4a6a6;

    //140221 gaz - not use temporary value

    // When use pay() func mapping more cheaper than list
    // 23501 gaz
    // mapping(address =>uint) payments;
    // function pay() external payable{
    //     require(msg.sender != address(0),"Address is 0");
    //     payments[msg.sender] = msg.value;
    // }

    // A dynamic list( uint[10]) is cheaper than a fixed-length list(uint[])
    // uint8[] demo = [1,2,3] is cheaper than (127248 gaz)
    // uint[] demo = [1,2,3] (158612 gaz)

    // It doesn't make sense to create a lot of small functions that call each other
    // 45917 gaz
    // uint c = 5;
    // uint d;

    // function call() public {
    //     uint a = 1 + c;
    //     d = a * c;
    // }

    // It is better not to modify the global variable in the loop but to create a temporary variable
    // 29749 gaz
    // uint public result =1;
    // function doWork(uint[]memory data) public{
    //     uint temp = 1;
    //     for(uint i= 0; i < data.length; i++){
    //         temp *=data[i];
    //     }
    //     result = temp;
    // }
}


contract Un {//It cost more funds

    //Static value
    //    uint demo = 0;gaz = 69324

    // 135362 gaz
    // uint128 a = 1;
    // uint256 c = 1;
    // uint128 b = 1;

    //89641 gaz
    // uint8 demo = 1;

    //116440 gaz - use 2 func(keccak256,encodePacked)
    // bytes32 public hash = keccak256(
    //     abi.encodePacked("test")
    // );



    //23514 gaz - use temporary value(_from) when called func
    //     mapping(address =>uint) payments;
    // function pay() external payable{
    //     address _from = msg.sender;
    //     require(_from != address(0),"Address is 0");
    //     payments[msg.sender] = msg.value;
    // }


    // When use pay() func lists more cost than mapping
    // 45621 gaz
    //    uint[] payments;
    // function pay() external payable{
    //     require(msg.sender != address(0),"Address is 0");
    //     payments.push(msg.value) ;
    // }

    // It doesn't make sense to create a lot of small functions that call each other
    // 46051 gaz
    // uint c = 5;
    // uint d;

    // function call() public {
    //     uint a = 1 + c;
    //     call2(a, c);
    // }

    // function call2(uint a, uint b) private {
    //     d = a * c;
    // }

    // It is better not to modify the global variable in the loop but to create a temporary variable
    // 30179
    //     uint public result =1;
    // function doWork(uint[]memory data) public{
    //     for(uint i= 0; i < data.length; i++){
    //         result *=data[i];
    //     }
    // }
}
