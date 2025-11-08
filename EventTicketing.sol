// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EventTicketing {
    address public owner;
    uint public nextEventId;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    struct Event {
        string name;
        uint date;
        uint price;
        uint totalTickets;
        uint ticketsSold;
        bool isCanceled;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;

    event EventCreated(uint eventId, string name, uint date, uint price, uint totalTickets);
    event TicketPurchased(address buyer, uint eventId, uint quantity);
    event EventCanceled(uint eventId);
    event TicketRefunded(address buyer, uint eventId, uint amount);
    event FundsWithdrawn(address owner, uint amount);

    function createEvent(string memory name, uint date, uint price, uint totalTickets) public onlyOwner {
        require(block.timestamp < date, "Event must be in future");
        require(totalTickets > 0, "Invalid ticket count");

        events[nextEventId] = Event(name, date, price, totalTickets, 0, false);
        emit EventCreated(nextEventId, name, date, price, totalTickets);
        nextEventId++;
    }

    function buyTicket(uint eventId, uint quantity) external payable {
        Event storage e = events[eventId];
        require(e.date != 0, "Event not found");
        require(!e.isCanceled, "Event canceled");
        require(block.timestamp < e.date, "Event started");
        require(e.ticketsSold + quantity <= e.totalTickets, "Not enough tickets");
        require(msg.value == quantity * e.price, "Wrong amount");

        e.ticketsSold += quantity;
        tickets[msg.sender][eventId] += quantity;

        emit TicketPurchased(msg.sender, eventId, quantity);
    }

    function getEvent(uint eventId) external view returns (Event memory) {
        return events[eventId];
    }

    function getMyTickets(uint eventId) external view returns (uint) {
        return tickets[msg.sender][eventId];
    }

    function cancelEvent(uint eventId) external onlyOwner {
        events[eventId].isCanceled = true;
        emit EventCanceled(eventId);
    }

    function refundTicket(uint eventId) external {
        Event storage e = events[eventId];
        uint count = tickets[msg.sender][eventId];
        require(e.isCanceled, "Not canceled");
        require(count > 0, "No tickets");

        tickets[msg.sender][eventId] = 0;
        uint refund = count * e.price;
        payable(msg.sender).transfer(refund);
        emit TicketRefunded(msg.sender, eventId, refund);
    }

    function withdrawFunds() external onlyOwner {
        uint amount = address(this).balance;
        payable(owner).transfer(amount);
        emit FundsWithdrawn(owner, amount);
    }
}
