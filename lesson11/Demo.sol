// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;


contract Ownable{
    address public owner;

    constructor(address ownerOverride){
        owner = ownerOverride == address(0) ? msg.sender : ownerOverride;
    }

    modifier onlyOwner(){
        require(owner == msg.sender,"Not an owner");
        _;
    }
        // virtual - значит что можно переопределить ниже по иерархии функцию

    function withdraw(address payable _to) public virtual onlyOwner{
        _to.transfer(address(this).balance);
    }
}

// Абстракный контракт не разворачивается, исп для настледования( можно развернуть)
abstract contract Balances is Ownable{

    function getBalance() public view onlyOwner returns(uint){
        return address(this).balance;
    }
// override - переопределяем функцию  
// override + virtual - переопределяем функцию,  и ниже по иерархии ее можно переопределить  
    function withdraw(address payable _to) public override virtual onlyOwner{
        _to.transfer(getBalance());
    }
}

// contract MyBalance is Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4), Balances{ если адресс известен заранее можно использовать такую конструкцию
// contract MyBalance is Balances{ Можно наследоваться так

contract MyBalance is Ownable, Balances{ 
    // constructor() Ownable(msg.sender){ Тот кто создает контракт - владелец
        constructor(address  _owner) Ownable(_owner){// Передаем адрес владельца контракта
        // owner = _owner; // Есть еще вариант переопределить значение родительского класса( предпочтительно  не использовать)
    }

    function withdraw(address payable _to) public override(Ownable, Balances) onlyOwner{
        // Balances.withdraw(_to);// Вызов ф-ции контракта Balances
        super.withdraw(_to);// Подымаемся на один уровень иерархии вверх(Balances) и вызываем ф-цию смарт контракта
        // Balances.withdraw(_to) == super.withdraw(_to)
    }
    
}

