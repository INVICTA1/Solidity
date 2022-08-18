// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


// Интерфейс описывает контракт, его ф-ции которые можно вызвать, можно наследовать, все ф-ции должны быть external,
interface ILogger {
    
    function log(address _from, uint _amount) external;

    function getEntry(address _from, uint _index) external view returns(uint);
}