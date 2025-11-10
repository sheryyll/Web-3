// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTMarketplace is ERC721URIStorage, Ownable {
    uint public tokenCounter;

    constructor() ERC721("NFT Marketplace", "NFTM") Ownable(msg.sender) {
        tokenCounter = 0;
    }

    struct Listing {
        uint tokenId;
        address payable seller;
        uint price;
        bool isListed;
    }

    mapping(uint => Listing) public listings;
    mapping(address => uint[]) public NFTowners;
    uint[] public listedTokens;

    event Minted(address indexed owner, uint tokenId, string tokenURI);
    event NFTListed(address indexed seller, uint tokenId, uint price);
    event NFTSold(address indexed buyer, uint tokenId, uint price);
    event NFTDelisted(uint tokenId);

    function mintNFT(string memory tokenURI) public {
        tokenCounter += 1;
        uint tokenId = tokenCounter;

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);

        NFTowners[msg.sender].push(tokenId);

        emit Minted(msg.sender, tokenId, tokenURI);
    }

    function listNFT(uint _tokenId, uint _price) public {
        require(ownerOf(_tokenId) == msg.sender, "Not NFT owner");
        require(_price > 0, "Price must be greater than zero");
        require(!listings[_tokenId].isListed, "Already listed");
        require(isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        listings[_tokenId] = Listing({
            tokenId: _tokenId,
            seller: payable(msg.sender),
            price: _price,
            isListed: true
        });

        listedTokens.push(_tokenId);

        emit NFTListed(msg.sender, _tokenId, _price);
    }

    function buyNFT(uint _tokenId) public payable {
        Listing memory listing = listings[_tokenId];
        require(listing.isListed, "NFT not listed");
        require(msg.value >= listing.price, "Insufficient payment");

        listing.seller.transfer(listing.price);
        _transfer(listing.seller, msg.sender, _tokenId);
        listings[_tokenId].isListed = false;

        emit NFTSold(msg.sender, _tokenId, listing.price);
    }

    function withdrawFees() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getListing(uint _tokenId) public view returns (Listing memory) {
        return listings[_tokenId];
    }

    function getAllListings() public view returns (Listing[] memory) {
        uint count = listedTokens.length;
        Listing[] memory activeListings = new Listing[](count);
        uint index = 0;

        for (uint i = 0; i < count; i++) {
            uint tokenId = listedTokens[i];
            if (listings[tokenId].isListed) {
                activeListings[index] = listings[tokenId];
                index++;
            }
        }

        return activeListings;
    }

    function getUserNFTs(address user) public view returns (uint[] memory) {
        return NFTowners[user];
    }
}
