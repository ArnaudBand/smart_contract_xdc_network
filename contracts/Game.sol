// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract Game is ERC721, ERC721URIStorage {
    address public owner;
    uint public currentLevel;
    uint public totalLevels;
    uint totalTokens;

    mapping(address => bool) public isRegistered;
    mapping(address => uint) public levelRewards;

    constructor() ERC721("GameNFT", "GNFT") {
        owner = msg.sender;
        currentLevel = 1;
        totalLevels = 5; // Replace with the desired total number of levels
        totalTokens = 0;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function."
        );
        _;
    }

    modifier onlyRegistered() {
        require(
            isRegistered[msg.sender],
            "You must be registered to play the game."
        );
        _;
    }

    function _setTokenURI(
        uint256 tokenId,
        string memory tokenURI
    ) internal virtual override {
        require(
            _exists(tokenId),
            "ERC721URIStorage: URI set of nonexistent token"
        );
        _tokenURIs[tokenId] = tokenURI;
    }

    function register(string memory playerName) external {
        require(!isRegistered[msg.sender], "You are already registered.");
        require(bytes(playerName).length > 0, "Player name cannot be empty.");

        isRegistered[msg.sender] = true;
        levelRewards[msg.sender] = 0;

        // Mint an NFT for the registered player
        uint tokenId = totalTokens + 1;
        _mint(msg.sender, tokenId);
        _setTokenURI(tokenId, playerName);

        totalTokens++;
    }


    function playGame(uint answer) external onlyRegistered {
        require(answer == currentLevel, "Incorrect answer. Try again.");

        // Calculate reward based on the level
        uint reward = calculateReward(currentLevel);

        // Update the player's reward for the current level
        levelRewards[msg.sender] = reward;

        // Increment the current level
        if (currentLevel < totalLevels) {
            currentLevel++;
        }
    }

    function calculateReward(uint level) internal pure returns (uint) {
        // Define the reward logic based on the level
        if (level == 1) {
            return 10; // Replace with the desired reward for level 1
        } else if (level == 2) {
            return 20; // Replace with the desired reward for level 2
        } else if (level == 3) {
            return 30; // Replace with the desired reward for level 3
        } else if (level == 4) {
            return 40; // Replace with the desired reward for level 4
        } else if (level == 5) {
            return 50; // Replace with the desired reward for level 5
        }
    }

    function withdrawRewards() external onlyRegistered {
        require(levelRewards[msg.sender] > 0, "No rewards to withdraw.");

        // Transfer the player's reward to their wallet
        // Replace this with the specific implementation for transferring the reward
        // using the player's registered wallet address
        uint rewardAmount = levelRewards[msg.sender];
        levelRewards[msg.sender] = 0;
    }

    function setTotalLevels(uint levels) external onlyOwner {
        totalLevels = levels;
    }
}
