// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Marketplace {

    struct Listing{
        address nftAddress;
        address seller;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    uint256 private _nextListingId;

    mapping (uint256 => Listing) public listings;

    // event for listing
    event ListingCreated(uint256 indexed listingId, address indexed seller, uint256 indexed tokenId, address nftContract, uint256 price); 

    // event for sale
    event Sale(uint256 indexed listingId, address indexed buyer, uint256 indexed tokenId); 

    // event for cancel 
    event Cancel(uint256 indexed ListingId, uint256 indexed tokenId,  address indexed seller);


    
    function listNFT(address nftAddress, uint256 tokenId, uint256 price) external returns (uint256)  {
        IERC721(nftAddress).transferFrom(msg.sender, address(this), tokenId); // transfer nft to marketplace
        listings[_nextListingId] = Listing(nftAddress, msg.sender, tokenId, price, true); // store listing
        emit ListingCreated(_nextListingId, msg.sender, tokenId, nftAddress, price); 

        uint256 listedId = _nextListingId; //store current Id
        _nextListingId++;                  // increment for next listing
        return listedId;                   // return current id
    }

    function buyNFT(uint256 listingId) external payable {
        Listing storage item = listings[listingId]; 
        require(item.active, "Listing not active"); // check if listing is active
        require(msg.value == item.price, "Incorrect amount"); // check if amount sent is equal to price of nft);

        item.active = false; // deactivate listing
        IERC721(item.nftAddress).transferFrom(address(this),msg.sender,item.tokenId); // transfer nft to buyer
        payable(item.seller).transfer(msg.value); // transfer funds to seller
        emit Sale(listingId, msg.sender, item.tokenId); 
    }

    function cancel(uint256 listedId) public {
        Listing storage item = listings[listedId];
        require(item.active,"Listing not active");
        require(msg.sender == item.seller, "Not seller"); // check if caller is seller;

        item.active = false; // deactivate listing
        IERC721(item.nftAddress).transferFrom(address(this),msg.sender,item.tokenId); // transfer nft back to seller
        emit Cancel(listedId, item.tokenId, msg.sender);
    }

    
}