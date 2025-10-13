// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Library{
    struct Book{
        string title;
        bool isAvailable;
    }
    Book[] public books;

    function addBook(string memory title) public{
        books.push(Book(title, true));
    }

    function  borrowBook(uint index) public{
        require(index < books.length, "Invalid book index");
        require(books[index].isAvailable, "Book is not available");
        books[index].isAvailable = false;
    }

    function returnBook(uint index) public{
        require(index < books.length, "Invalid book index");
        books[index].isAvailable = true;
    }

    function getBook(uint index) public view returns (string memory, bool){
        require(index < books.length, "Invalid book index");
        Book memory book = books[index];
        return (book.title, book.isAvailable);
    }
}