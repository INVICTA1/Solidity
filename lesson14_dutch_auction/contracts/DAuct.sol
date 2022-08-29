pragma solidity ^0.8.0;

contract DutchAuction {
    uint private constant DURATION = 2 days;
    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable endAt;
    uint public immutable discountRate;
    string public item;
    bool public stopped;

    event Bought(uint price,address buyer);

    constructor(uint _startingPrice, uint _discountRate, string memory _item){
        require(discountRate * DURATION < _startingPrice, "price too low");
        discountRate = _discountRate;
        item = _item;
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        endAt = block.timestamp + DURATION;
        seller = payable(msg.sender);
    }

    modifier notStopped(){
        require(!stopped, "has already stopped");
        _;
    }

    function getPrice() view public notStopped returns (uint){
        return startingPrice - discountRate * (block.timestamp - startAt);
    }

    function buy() external payable notStopped(){
        require(block.timestamp < endAt, "too late");
        require(!stopped, "auction stopped" );
        uint price = getPrice();
        require(msg.value >= price, "too low funds");
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        seller.transfer(address(this).balance);
        stopped = true;
        emit Bought(price, msg.sender);

    }
}
