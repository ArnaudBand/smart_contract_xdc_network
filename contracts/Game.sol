// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.18;

import "./XRC1155.sol";

contract Game is XRC1155 {
    // using Strings for uint256;

    address public owner;
    uint256 public currentLevel;
    uint256 public totalLevels;
    uint256 public totalTokens;
    uint256 public rewardAmount;
    string private baseURI;

    mapping(address => uint256) public registeredPlayers;
    mapping(address => uint256) public levelRewards;
    mapping(uint256 => string) private _tokenURIs;

    constructor() XRC1155() {
        owner = msg.sender;
        currentLevel = 1;
        totalLevels = 5;
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
            registeredPlayers[msg.sender] != 0,
            "You must be registered to play the game."
        );
        _;
    }

    function register(string memory playerName) external {
        require(registeredPlayers[msg.sender] == 0, "You are already registered.");
        require(bytes(playerName).length > 0, "Player name cannot be empty.");

        // Mint an NFT for the registered player
        uint256 tokenId = totalTokens + 1;
        balances[tokenId][msg.sender] = 1;
        totalTokens++;

        // Set the token URI
        _setTokenURI(tokenId, playerName);

        // Register the player with the token ID
        registeredPlayers[msg.sender] = tokenId;
    }

    function login() external view returns (bool) {
        // Verify if the player has the same NFT token they received during registration
        return balanceOf(msg.sender, registeredPlayers[msg.sender]) > 0;
    }

    function balanceOf(address account, uint256 tokenId) public override view returns (uint256) {
        return balances[tokenId][account];
    }

    function playGame(uint256 answer) external onlyRegistered {
        require(answer == currentLevel, "Incorrect answer. Try again.");

        // Calculate reward based on the level
        uint256 reward = calculateReward(currentLevel);

        // Update the player's reward for the current level
        levelRewards[msg.sender] = reward;

        // Increment the current level
        if (currentLevel < totalLevels) {
            currentLevel++;
        }
    }

    function calculateReward(uint256 level) internal pure returns (uint256 reward) {
        // Define the reward logic based on the level
        if (level == 1) {
            return reward =10; // Replace with the desired reward for level 1
        } else if (level == 2) {
            return reward = 20; // Replace with the desired reward for level 2
        } else if (level == 3) {
            return reward = 30; // Replace with the desired reward for level 3
        } else if (level == 4) {
            return reward = 40; // Replace with the desired reward for level 4
        } else if (level == 5) {
            return reward = 50; // Replace with the desired reward for level 5
        }
    }

    function withdrawRewards() external onlyRegistered {
        require(levelRewards[msg.sender] > 0, "No rewards to withdraw.");

        // Transfer the player's reward to their wallet
        // Replace this with the specific implementation for transferring the reward
        // using the player's registered wallet address
        rewardAmount = levelRewards[msg.sender];
        levelRewards[msg.sender] = 0;
    }

    function setTotalLevels(uint256 levels) external onlyOwner {
        require(levels > totalLevels, "The total levels cannot be decreased.");
        totalLevels = levels;
    }

    function setBaseURI(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
    }


    function uri(uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(tokenId), "ERC1155Metadata: URI query for nonexistent token");

        string memory tokenURI = _tokenURIs[tokenId];
        return bytes(tokenURI).length > 0 ? tokenURI : "";
    }

    function _setTokenURI(uint256 tokenId, string memory tokenURI) internal {
        require(_exists(tokenId), "ERC1155Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = tokenURI;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return bytes(_tokenURIs[tokenId]).length > 0;
    }
}
