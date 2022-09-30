pragma solidity ^0.8.0;

contract MyContract {
    //    Первые 64 байта зарезервиррованное место, свободное место начинается после 64 байтт и храниться указатель на это место
    //    Слоты памяти по 32 байта
    function work(string memory _str) external pure returns (bytes32 data){
        assembly {
        //            mload - func that read smth from memory
            let ptr := mload(0x40)
            data := mload(sub(ptr, 32))
        }
        // Что бы взять значение из памяти  
        //          or 64 (64 = 0x40)
        // ptr = 192 байт и после него ничего нет, строка str находиться
        // что-бы взять str напрямую отнимем от 192 32(одна ячейка памяти  и получим)
        // bytes32: data 0x7465737400000000000000000000000000000000000000000000000000000000 = "test"
    }

    function workMass(uint[3] memory _arr) external pure returns (bytes32 data){
        assembly {
            let ptr := mload(64)
            data := mload(sub(ptr, 32))// last elem of arr = // Get bytes32: data 0x0000000000000000000000000000000000000000000000000000000000000003
        // data := mload(sub(ptr,64))// middle elem of arr
        // data := mload(sub(ptr,96))// first elem of arr
        }
    }
    // Calldata - дешевле т к не нужно делать операцию копирования в память
    // msg.data = calldata - данные нашего вызова
    // msg.data сохраняется в blockchain, если не выполняем call    
    function callDataMemory(uint[3] memory _arr) external pure returns (bytes memory){
        return msg.data;
        // output - bytes: 0x176447dd0000000000000000000000000000000000000000000000000000000000000001
        // 0000000000000000000000000000000000000000000000000000000000000002
        // 0000000000000000000000000000000000000000000000000000000000000003
        // 176447dd - selector func that we want call

    }

    // Get signature of func 
    // msg.data[0:4] - селектор можно считать таким образом, т.к. он всегда занимет первые 4-е байта всегда
    function getSignature() external pure returns (bytes4){
        return bytes4(keccak256(bytes("callDataMemory(uint256[3])")));
        // output - bytes4: 0x176447dd

    }

    function callDataCalldata(uint[3] calldata _arr) external pure returns (bytes32 _el1){
        assembly {
        // calldataload - считывае calldata напрямую, первые 4-е байта занимает selector поэтому начинаем читать с 4-го
            _el1 := calldataload(4)// Считываем 1-й эл массива  
        }
        // output - bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000001
    }

    function callDataStr(string calldata _str) external pure returns (bytes32 _el1){
        // Такая же структура с строками и  динамическими массивами
        // assembly {
        //     _el1 := calldataload(4)  
        // }
        // output - bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000020 - 
        // 20 в 16-м виде,  в 10-чном 32, значит через 32 байта будет информация о строке
        // assembly {
        //     _el1 := calldataload(add(4,32))  
        // }
        // output - bytes32: _el1 0x0000000000000000000000000000000000000000000000000000000000000004 - длина 4 байта, эта информация занимает еще 32 байта 
        assembly {
            _el1 := calldataload(add(4, 64))
        }
        // output - bytes32: _el1 0x7465737400000000000000000000000000000000000000000000000000000000 = "test"


    }

    function callDataDynamicArr(uint[] calldata _arr) external pure returns (
        bytes32 _startIn, bytes32 _elCount, bytes32 _firstEl){
        assembly {
            _startIn := calldataload(4)
            _elCount := calldataload(add(4, 32))
            _firstEl := calldataload(add(4, 64))
        }
        // input [1,2,3]
        // output 
        // bytes32: _startIn 0x0000000000000000000000000000000000000000000000000000000000000020
        // 1:
        // bytes32: _elCount 0x0000000000000000000000000000000000000000000000000000000000000003
        // 2:
        // bytes32: _firstEl 0x0000000000000000000000000000000000000000000000000000000000000001


    }

    //  calldata  - неизменяемое хранилеще данных, содержит всю инф-ю какую ф-цию вызвать и с какими аргументами
    // function callDataDynamicArr(uint[] calldata _arr) -calldata - напрямую читаем инф-ю
    // function callDataDynamicArr(uint[] memory _arr) - memory - копируем в память данные, стоит дороже
}