 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Investor {
    uint public totalWagers;
    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner () {
        require(msg.sender == owner, "Action for owner only");
        _;
    }
    function getTotalDonations()  public view returns(uint) {
        return totalWagers;
    }

    function deposit() public payable {}

    ///@notice accepts the wagers sent for investment
    function invest() public payable {
        (bool success,) = owner.call{value: msg.value}("");
        require(success, "Failed to send money");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}