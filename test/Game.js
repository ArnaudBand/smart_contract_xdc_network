const Game = artifacts.require("Game");
const { expect } = require("chai");

contract("Game", async (accounts) => {
  let game;
  const player = accounts[1];

  beforeEach(async () => {
    game = await Game.new();
  });

  it("should register a player", async () => {
    const playerName = "Alice";
    await game.register(playerName, { from: player });
    const isPlayerRegistered = await game.isRegistered.call(player);
    expect(isPlayerRegistered).to.be.true;
  });

  it("should play the game and update the player's reward", async () => {
    await game.register("Bob", { from: player });
    const currentLevel = await game.currentLevel.call();
    await game.playGame(currentLevel, { from: player });
    const expectedReward = await game.calculateReward.call(currentLevel);
    const playerReward = await game.levelRewards.call(player);
    expect(playerReward.toNumber()).to.equal(expectedReward.toNumber());
  });

  it("should withdraw the player's rewards", async () => {
    await game.register("Charlie", { from: player });
    await game.playGame(await game.currentLevel.call(), { from: player });
    const playerReward = await game.levelRewards.call(player);
    await game.withdrawRewards({ from: player });
    const withdrawnReward = await game.levelRewards.call(player);
    expect(withdrawnReward.toNumber()).to.equal(0);
  });
    const expectedTotalLevels = 10;
    await game.setTotalLevels(expectedTotalLevels);
    const totalLevels = await game.totalLevels.call();
    expect(totalLevels.toNumber()).to.equal(expectedTotalLevels);
  });
// });
