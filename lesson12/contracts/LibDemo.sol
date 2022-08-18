// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Ext.sol";

contract LibDemo {
    // Connect library for type of data
    using StrExt for string;
    using ArrayExt for uint[];

    function runStr(string memory str1, string memory str2) public pure returns (bool){
        return str1.eq(str2);
    }

    function runArray(uint[] memory array, uint el) public pure returns (bool){
        // return array.inArray(el);
        return ArrayExt.inArray(array, el);
    }

}