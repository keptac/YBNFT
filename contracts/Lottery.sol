// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Investor.sol";

/// @title A no loss lottery
contract Lottery {
    address public owner;
    uint256 private lotteryDuration;
    uint public totalWagers;
    mapping(address => bool) public hasInvested;
    
    ///@notice An iterable mapping of users and their total wager. Maps user address to their wager amount
    address[] public users;
    ///@notice User wager balance
    mapping(address => uint) public wager;

    Investor public investor;

    event Transfer(
        address indexed _from,
        uint256 _value
    );
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Action for lottery owner only");
        _;
    }

    constructor(Investor _investor) {
        investor = _investor;
        owner = msg.sender;
    }

    /// @param numberOfDays The number of days from now the lottery is going to be running.
    /// @notice You can use this contract for only the most basic simulation
    function setLotteryDuration(uint256 numberOfDays) public onlyOwner {
        lotteryDuration = block.timestamp + (numberOfDays * 1 days);
    }

    ///@param _amount The amount send to investor contract
    ///@notice Sends wagers to investor - the user is staking their money(wager)
    ///@dev it sends the wagers to the investor contract, then updates the users array and finally updates user's total wager which is mapped by address
    function stakeWager(uint256 _amount) public {
        require(_amount > 0, "Amount cannot be 0");
        require(block.timestamp >= lotteryDuration, "Lottery duration ended");

        ///@notice Trasnfer amount from user to Investor Contract
        investor.invest{ value: _amount }();

        ///@notice Update the total amount of wagers invested in the lottery
        totalWagers += _amount;

        wager[msg.sender] = wager[msg.sender] + _amount;
        
        if(!hasInvested[msg.sender]) {
            users.push(msg.sender);
        }

        hasInvested[msg.sender] = true;

        emit Transfer(msg.sender, _amount);
    }

    function stakingBalance(address account) public view returns(uint){
        return wager[account];
    }
}
