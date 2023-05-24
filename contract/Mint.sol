pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC1155 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    
    address private _owner;
    
    constructor() ERC1155("https://myapi.com/token/{id}.json") {
        _owner = msg.sender;
        // Mint an initial token
        mint(msg.sender);
    }
    
    //function for the mint
    function mint(address account) public {
        require(msg.sender == _owner, "Only the owner can mint tokens");
        uint256 newItemId = _tokenIdTracker.current();
        _mint(account, newItemId, 1, "");
        _tokenIdTracker.increment();
    }
    
    //function for transferring the ownership of the token 
    function transferOwner(address newOwner) public {
        require(msg.sender == _owner, "Only the owner can transfer ownership");
        require(newOwner != address(0), "Invalid new owner address");
        _owner = newOwner;
    }
}
