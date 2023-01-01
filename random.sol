// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract random{

    // making a random number between 0 to "range"
    // use keccak256 to make a hash
    // use abi.encodepacked to make a complex number mixed of timestamp and difficulty


    function randomMaker(uint range)internal view virtual returns (uint){
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp , block.difficulty)))%range +1;
        return rand;
    }

}