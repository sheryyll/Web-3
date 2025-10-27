// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MiniMarketplace {

    address public owner;
    uint public productCount;

    struct Product {
        string name;
        uint price;
        address seller;
        bool sold;
    }

    mapping(uint => Product) public products;

    constructor() {
        owner = msg.sender;
    }

    function addProduct(string memory _name, uint _price) internal {
        productCount++;
        products[productCount] = Product(_name, _price, msg.sender, false);
    }

    function markSold(uint _id) internal {
        products[_id].sold = true;
    }

    function listProduct(string memory _name, uint _price) public {
        addProduct(_name, _price);
    }

    function buyProduct(uint _id) public payable {
        Product storage product = products[_id];
        require(!product.sold, "Product already sold.");
        require(msg.value >= product.price, "Insufficient funds to buy this product.");

        markSold(_id);
        payable(product.seller).transfer(msg.value);
    }
}
