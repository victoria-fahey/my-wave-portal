// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

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

    constructor() {
        console.log("I am a contract and I am smart");
    }

    // function requires a string called _message
    // message the user sends us from the frontend
    function wave(string memory _message) public {
        totalWaves += 1;
        console.log("%s has waved! with message: %s", msg.sender, _message);

        // store wave data in the array
        waves.push(Wave(msg.sender, _message, block.timestamp));

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
