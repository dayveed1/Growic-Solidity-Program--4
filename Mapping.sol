pragma solidity >=0.4.16 <0.9.0;
//SPDX-License-Identifier: MIT


import "hardhat/console.sol";

/// Contract
contract MyContract {

    //owmer
    address payable owner;

    // maps addr to balance 
    mapping(address => uint256) balance;

    //get  the balance  
    function getBalance(address addr) private view returns (uint){
        uint256 amount = balance[addr];
        console.log("addr %s balance %s ", addr, amount);
        return amount;
    }

    //set the balance 
    function setBalance(address addr, uint256 amount) private {
        balance[addr] = amount;
        console.log("Balance set to %s for addr %s", amount, addr);
    }

    //delete the balance 
    function deleteBalance(address addr) private {
        delete balance[addr];
        console.log("Deleted %s", addr);
    }

    // required functions 
    function deposit(uint256 amount) public {
        return setBalance(msg.sender, amount + getBalance(msg.sender) );
    }

    function checkBalance() public view returns (uint256) { 
        // remove view property to be able to send from scafold ui
        return getBalance(msg.sender);
    }


    constructor() payable {
        // original owner is contract creator
        owner =  payable(msg.sender);
    }


    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}