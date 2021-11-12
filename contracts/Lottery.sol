// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Investor.sol";

/// @title A no loss lottery
/// @author Kelvin P. Chelenje
contract Lottery {
    address public owner;
    uint256 private lotteryDuration;
    uint public totalWagers;

    Investor public investor;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    
    /// @notice An iterable mapping of users and their total wager. Maps user address to their wager amount
    mapping(address => uint)[] public userWagers;

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

    ///@param _amount The amount send to investor.
    ///@notice Sends wagers to investor
    function stakeWager(uint256 _amount) public {
        require(_amount > 0, "amount cannot be 0");
        require(block.timestamp >= lotteryDuration, "Lottery duration ended");

        ///@notice Trasnfer amount from user to Investor Contract
        investor.invest{ value: _amount }();

        // emit Transfer(msg.sender, investor, _amount);
    }
}
