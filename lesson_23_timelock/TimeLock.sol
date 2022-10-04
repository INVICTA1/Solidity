pragma solidity ^0.8.0;

contract TimeLock {
    address[] public owners;
    string public message;
    uint public amount;
    uint constant MINDELAY = 10;
    uint constant MAXDELAY = 1 days;
    uint constant GRACEPERIOD = 1 days;
    uint constant public CONFIRMATIONS_REQUIRED = 3;

    struct Transaction {
        bytes32 uid;
        address to;
        uint value;
        bytes data;
        bool executed;
        uint confirmations;
    }

    mapping(bytes32 => Transaction) public txs;
    // Transaction[] public txs;

    mapping(bytes32 => mapping(address => bool)) public confiramtions;
    mapping(bytes32 => bool) public queue;
    mapping(address => bool) public isOwner;


    event Queued(address sender, bytes32 txId);
    event Discard(address sender, bytes32 txId);
    event Executed(address sender, bytes32 txId);

    modifier onlyOwner(){
        require(isOwner[msg.sender], "not an owner");
        _;
    }

    constructor(address[] memory _owners){
        uint owners_length = _owners.length;
        require(owners_length >= CONFIRMATIONS_REQUIRED, "not enough owners");
        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner == address(0), "can't have zero address");
            require(isOwner[owner], "duplicate address");

            isOwner[owner] = true;
            owners.push(owner);
        }
    }

    function addToQueue(
        address _to,
        string calldata _func,
        bytes calldata _data,
        uint _value,
        uint _timestamp
    ) external onlyOwner returns (bytes32){
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
        //         address to;
        // uint value;
        // bytes data;
        // bool executed;
        // uint confirmations;
        txs[txId] = Transaction({
        uid : txId,
        to : address(_to),
        value : _value,
        data : _data,
        executed : false,
        confirmations : 0

        });
        // txs.push(Transaction({
        //     uid:txId,
        //     to:address(_to),
        //     value: _value,
        //     data : _data,
        //     executed : false,
        //     confirmations: 0

        // }));

        emit Queued(msg.sender, txId);

        return txId;

    }

    function confirmTransaction(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "already queue");
        require(!confiramtions[_txId][msg.sender], "already confirmed");

        Transaction storage transaction = txs[_txId];

        transaction.confirmations++;
        confiramtions[_txId][msg.sender] = true;
    }

    function cancelConfirmTransaction(bytes32 _txId) external onlyOwner {
        require(queue[_txId], "already queue");
        require(confiramtions[_txId][msg.sender], "not confirmed");

        Transaction storage transaction = txs[_txId];

        transaction.confirmations--;
        confiramtions[_txId][msg.sender] = false;
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

        Transaction storage transaction = txs[txId];
        require(transaction.confirmations >= CONFIRMATIONS_REQUIRED, "not enough confirmations");

        queue[txId] = false;

        transaction.executed = true;
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

    function prepareData(string calldata _msg) external pure returns (bytes memory){
        return abi.encode(_msg);

    }

    //    Testing contract
    function demo(string calldata _msg) external payable {
        message = _msg;
        amount = msg.value;

    }
}
