// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract PortfolioNFT is ERC721, ERC721URIStorage, Ownable {
    // Counter for the next token ID
    uint256 private _nextTokenId;

    // Fixed mint price for each NFT (0.01 ETH)
    uint256 private mintPrice = 0.01 ether;

    // Event emitted whenever a new NFT is minted
    event Minted(address indexed to, uint256 indexed tokenId, uint256 price);

    // Event emitted whenever the owner withdraws contract funds
    event Withdraw(address owner, uint256 amount);

    // Constructor sets the token name, symbol, and contract owner
    constructor()
        ERC721("PortfolioNFT", "PNFT")
        Ownable(msg.sender)
    {}

    // Returns the base URI for all token metadata
    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://bafybeiaeeocazxnjfkl2ul4p7akbj3w4ijkx6d27vj74rzssvgauoeodye/";
    }

    // Allows anyone to mint an NFT by paying the exact mint price
    function safeMint()
        public
        payable 
        returns (uint256)
    {
        require(msg.value == mintPrice, "Insufficient ETH");
        uint256 tokenId = _nextTokenId++;            // Increment token ID counter
        _safeMint(msg.sender, tokenId);              // Safely mint NFT to caller
        emit Minted(msg.sender, tokenId, mintPrice); // Emit mint event
        return tokenId;
    }

    // Allows the contract owner to withdraw all collected ETH
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        payable(msg.sender).transfer(balance);       // Send all ETH to owner
        emit Withdraw(msg.sender, balance);          // Emit withdrawal event
    }

    // The following functions are required overrides for ERC721 + ERC721URIStorage
    
    // Returns metadata URI for a given tokenId
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Confirms contract supports the requested interface
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
