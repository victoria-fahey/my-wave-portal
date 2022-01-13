// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // generate random number:
    uint256 seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    // struct is a custom datatype where we can customise what we want to hold inside it
    struct Wave {
        address waver; // address of user who waved
        string message; // message the user sent
        uint256 timestamp; // timestamp when the user waved
    }

    // variable called waves that stores an array of structs
    // can hold all the waves anyone ever sends
    Wave[] waves;

    // mapping = key value pairs
    // mapping an address with a number
    // here we are storing the address with the last time the user waved at us
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("I am a contract and I am smart");
        // set the initial seed:
        // combine timestamp & difficulty to create random numebr
        seed = (block.timestamp + block.difficulty) % 100;
    }

    // function requires a string called _message
    // message the user sends us from the frontend
    function wave(string memory _message) public {
        // make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "wait 15m"
        );

        // update the current timestamp we have for the user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved! with message: %s", msg.sender, _message);

        // store wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed for the next user that sends a waves
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        // give 50% change that the user wins the prize:
        if (seed <= 50) {
            console.log("%s won!", msg.sender);
            // setting up sending amount of eth as a prize
            uint256 prizeAmount = 0.0001 ether;
            // require = fancy if statement
            // if the balance of hte contract is > prize amount give the prize,
            // if not kill the transaction
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        // events are called using 'emit'
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    // returns the struct array where we can retrieve the waves from our website
    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }
}
