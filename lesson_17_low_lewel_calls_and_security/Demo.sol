// SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;


contract AnotherContract {
    string public name;
    mapping(address => uint) public balances;

    function setName(string calldata _name) external returns (string memory){
        name = _name;
        return name;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
    }
}

contract NyContract {
    address otherContract;

    event Response(string response);

    constructor(address _otherContract){
        otherContract = _otherContract;
    }
    // Низкоуровневый вызов receive метода AnotherContract
    function callReceive() external payable {
        (bool success,) = otherContract.call{value : msg.value}("");

        require(success, "can't send funds");
        // При иcпользовании transfer для передачи денег, если дентги не дойдут, ф-я породит ошибку и тр-ция будет откачена
        // transfer() не передает больше 2300 gaz
        // transfer() не надежен от reentrancy 
    }

    function callSetName(string calldata _name) external {
        // Вызываем ф-цию контракта
        (bool success, bytes memory response) = otherContract.call(
            abi.encodeWithSignature("setName(string)", _name)// Универсальная форма вызова
        // Если есть доступ к исходнику контракта можем вызывать
        // abi.encodeWithSelector(AnotherContract.setName.selector, _name)//Не нужно прописывать аргументы

        );
        require(success, "can't set name");
        emit Response(abi.decode(response, (string)));
        // emit Response(abi.decode(response,(string)));
    }


}
    
