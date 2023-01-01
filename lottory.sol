// SPDX-License-Identifier: MIT

import "./random.sol"; 

pragma solidity ^0.8.0;

contract lottory is random{
    // the lottory rolls
    // every participant can buy a ticket
    // the owner will get a comission on every ticket
    // after the last day, the winner will get the prize

    // the ticket details
    struct ticket{
        // ticket id
        uint id;
        // ticket owner
        address payable participant;
        // time of buying the ticket
        uint creatDateTime;
    
        // checking if the member wins the lottory or not
        bool win;

    }

    // the leader of the lottory
    address payable public owner;

    // storing the data of the tickets to any member
    mapping(uint => ticket) public tickets;

    // starting date of the contract
    uint public startDate;

    //ticket price
    uint ticketPrice;

    // the number of days when the lottory is valid
    uint16 public day;
    // total value of the tickets that have bought by participants
    uint invested = 0;
    // the number of ticket which have bought untill now
    uint ticketCode = 0;
    // status of ending the lottory
    bool endinglottory;

    // buying tickets
    event ticketBuy(address indexed _address, uint _amount , uint _ticketCount);
    // winning tickets
    event ticketWin(address indexed _address, uint _amount , uint _ticketCount);

    constructor (uint16 day_ , uint ticketPrice_) {
        day = day_;
        owner = payable(msg.sender);
        ticketPrice = ticketPrice_;
        startDate = block.timestamp;
    }

    // buying a ticket by user
    // 10 percent of the ticket price will bee send to the owner
    function ButTicket () public payable returns(uint){
        require(msg.value == ticketPrice,"the balance is not sufficiant");
        require(block.timestamp < startDate + (day*84600), "the lottory is ended");
        require(msg.sender != owner , "the owner can't buy a ticket");
        ticketCode++;
        owner.transfer(msg.value / 10);
        invested += (msg.value * 90)/100;
        tickets[ticketCode] = ticket(ticketCode , payable(msg.sender), block.timestamp , false);
        emit ticketBuy (msg.sender , msg.value , ticketCode);
        return ticketCode;
    }

    // after lottory time finished, the owner can start it and winner can get all the prize
    function startLottory () public {
        require(msg.sender == owner , "the caller is not owner");
        require(block.timestamp > startDate + (day*84600), "the lottory is not ended");
        require(endinglottory == false, "the lottoay is alredy Done");
        uint winnerID = randomMaker(ticketCode);
        tickets[winnerID].win = true;
        endinglottory = true;
        tickets[winnerID].participant.transfer(invested);
        emit ticketWin (tickets[winnerID].participant, invested , winnerID);
    }


    // making a random number
    // imported from random.sol
    function randomMaker(uint range)internal view override returns (uint){}
    

}