// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.18;

/**
    Note: Simple contract to use as base for const vals
*/
contract CommonConstants {

    bytes4 constant internal XRC1155_ACCEPTED = 0xf23a6e61; // bytes4(keccak256("onXRC1155Received(address,address,uint256,uint256,bytes)"))
    bytes4 constant internal XRC1155_BATCH_ACCEPTED = 0xbc197c81; // bytes4(keccak256("onXRC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
}