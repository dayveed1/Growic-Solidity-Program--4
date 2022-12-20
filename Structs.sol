pragma solidity >=0.4.16 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

/// User Doesn't Exist custom error
error UserDoesntExist();

/// Contract
contract MyContract {

    //Owner
    address payable owner;

    /// User struct
    struct User {
        string name;
        uint256 age; //unint256 for age come on! uint8 => 255 years old is enought
        // in blockchain storage is money ...
    }

    /// maps addr to user
    mapping(address => User) usersMap;
    
    // get function
    function getUser(address addr) private view returns (User memory) {
        
        if( usersMap[addr].age == 0 ){ 
            // age easier  to check than name since its a string
            console.log("User doesn t exist");
            revert UserDoesntExist();
        }
        User memory user = usersMap[addr];
        console.log("User Found: {name: %s, age: %s} for address: %s", user.name, user.age, addr);
        return user;
    }

    // set function
    function setUser(address addr, User memory user) private {
        usersMap[addr] = user;
        console.log("Added user: {name: %s, age: %s} for address: %s", user.name, user.age, addr);
    }
    
    // delete function
    function deleteUser(address addr) private {
        delete usersMap[addr];
        console.log("Delete user at address %s", addr);
    }


    /// maps addr to balance 
    mapping(address => uint256) balance;

    // get function 
    function getBalance(address addr) private view returns (uint){
        uint256 amount = balance[addr];
        console.log("addr %s balance %s ", addr, amount);
        return amount;
    }

    // set function
    function setBalance(address addr, uint256 amount) private {
        balance[addr] = amount;
        console.log("Balance set to %s for addr %s", amount, addr);
    }

    // delete function
    function deleteBalance(address addr) private {
        delete balance[addr];
        console.log("Deleted %s", addr);
    }

    /// required user details functions 

    function setUserDetails(string calldata name, uint256 age) public {
        User memory user = User(name, age);
        setUser(msg.sender, user);
    }

    function getUserDetail() public view returns (User memory) {
        // remove view property to be able to send from scafold ui
        return getUser(msg.sender);
    }

    function deposit(uint256 amount) public {
        getUserDetail(); // reverts if user doesnt exist
        // you have to be a registered user in order to deposit
        return setBalance(msg.sender, amount + getBalance(msg.sender) );
    }

    function checkBalance() public  view returns (uint256) { 
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