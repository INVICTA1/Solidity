pragma solidity ^0.8.0;

contract TimeLock {
    address public owner;
    string public message;
    uint public amount;
    uint constant MINDELAY = 10;
    uint constant MAXDELAY = 1 days;
    uint constant GRACEPERIOD = 1 days;
    mapping(bytes32 => bool) public queue;

    modifier onlyOwner(){
        require(msg.sender == owner, "not an owner");
        _;
    }

    event Queued(address sender, bytes32 txId);
    event Discard(address sender, bytes32 txId);
    event Executed(address sender, bytes32 txId);

    constructor(){
        owner = msg.sender;
    }

    function addToQueue(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint _value,
        uint _timestamp
    ) external onlyOwner returns(bytes32){
        require(
            _timestamp >= block.timestamp + MINDELAY &&
            _timestamp < block.timestamp + MAXDELAY,
            "Invalid timestamp"
        );
        bytes32 txId = keccak256(abi.encode(
                _to,
                _func,
                _data,
                _value,
                _timestamp
            ));

        require(!queue[txId], "already queue");
        queue[txId] = true;

        emit Queued(msg.sender, txId);

        return txId;

    }

    function execute(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint _value,
        uint _timestamp
    ) external payable onlyOwner returns (bytes memory){

        require(_timestamp < block.timestamp, "Too early");
        require(_timestamp + GRACEPERIOD > block.timestamp, "Tx expired");
        bytes32 txId = keccak256(abi.encode(
                _to,
                _func,
                _data,
                _value,
                _timestamp
            ));
        require(queue[txId], "not queued");
        queue[txId] = false;
        // or delete queue[_txId];

        bytes memory data;
        //2 варианта
        //1)Указано название ф-ции и эт у ф-цию нужно закодировать вместе с данными
        //2)Ф-ции нет => вызываем callback
        if (bytes(_func).length > 0) {
            data = abi.encodePacked(
                bytes4(keccak256(bytes(_func))),
                _data
            );
        } else data = _data;
        (bool success, bytes memory resp) = _to.call{value : _value}(data);
        require(success, "not success");

        emit Executed(msg.sender, txId);
        return resp;
    }

    function discard(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "not queued");
        queue[_txId] = false;
        //delete queue[_txId];
        emit Discard(msg.sender, _txId);
    }
    //    Funcs for testing contract

    function getTimestamp(uint time) external view returns (uint){
        return block.timestamp + time;
    }

    function prepareData(string calldata _msg) external pure returns(bytes memory){
        return abi.encode(_msg);

    }

    //    Testing contract
    function demo(string calldata _msg) external payable {
        message = _msg;
        amount = msg.value;

    }
}
