// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
const path = require('path');
const fs = require('fs');

async function main() {
  
  // Compile the contract
  const compiledContract = await ethers.getContractFactory('Game');
  const contract = await compiledContract.deploy();

  // Wait for the contract to be deployed
  await contract.deployed();

  // Get the contract address and ABI
  const contractAddress = contract.address;
  const contractABI = contract.interface.format('json');

  // Save the contract address and ABI to a JSON file
  // const contractData = {
  //   address: contractAddress,
  //   abi: contractABI,
  // };
  // const outputFilePath = path.join(__dirname, 'GameContract.json');
  // fs.writeFileSync(outputFilePath, JSON.stringify(contractData, null, 2));

  console.log('Contract deployed successfully!');
  console.log('Contract address:', contractAddress);
  // console.log('Contract ABI saved to:', outputFilePath);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
