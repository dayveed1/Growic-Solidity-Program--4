pragma solidity >=0.4.16 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";


/// User Doesn't Exist custom error
error UserDoesntExist();

/// Error not Owner
error NotOwner(address owner, address sender);

/// Error no Funds
error UserHasNoFunds(address userAddress);

/// Error cannot add funds
error UserCannotAddFunds(address userAddress);

/// Error AmountTooSmall
error AmountToSmall();

/// Contract
contract YourContract {
    /// Owner address
    address payable owner;
    /// Owner funds
    uint256 public ownerFunds = 0;
    /// Owner fee
    uint8 public Fee = 10;

    /// User struct
    struct User {
        string name;
        uint256 age; //unint256 for age come on! uint8 => 255 years old is enough
        // in blockchain storage is money ...
        bool canAddFunds;
    }

    /// maps addr to user
    mapping(address => User) usersMap;

    /// maps addr to balance
    mapping(address => uint256) balance;

    /// required functions
    function withdraw(address addr) public OnlyOwner UserHasFunds(addr) {
        ownerFunds = ownerFunds + balance[addr];
        balance[addr] = 0;
    }

    function addFunds(uint256 amount)
        public
        UserCanAddFunds
        UserHasFunds(msg.sender)
        AmoutValid(amount)
    {
        balance[msg.sender] = balance[msg.sender] + amount - Fee;
        ownerFunds = ownerFunds + Fee;
    }

    function setUserDetails(string calldata name, uint256 age) public {
        usersMap[msg.sender] = User(name, age, false);
        emit ProfileUpdated(msg.sender);
    }

    function getUserDetail() public view returns (User memory) {
        console.log(
            "Adddress %s is {name: %s, age: %s}",
            msg.sender,
            usersMap[msg.sender].name,
            usersMap[msg.sender].age
        );
        return usersMap[msg.sender];
    }

    function deposit(uint256 amount) public AmoutValid(amount) {
        User memory user = getUserDetail();
        // reverts if user does not exist
        // you have to be a registered user in order to deposit
        if (bytes(user.name).length == 0) {
            revert UserDoesntExist();
        }

        balance[msg.sender] = balance[msg.sender] + amount - Fee;
        //unlock addFunds
        usersMap[msg.sender].canAddFunds = true;
        emit FundsDeposited(msg.sender, amount - Fee);
    }

    function checkBalance() public view returns (uint256) {
        console.log("Adddress %s has %s", msg.sender, balance[msg.sender]);
        return balance[msg.sender];
    }

    /// required Events
    event ProfileUpdated(address user);
    event FundsDeposited(address user, uint256 amount);

    constructor() payable {
        // original owner is contract creator
        owner = payable(msg.sender);
    }

    // modifiers
    modifier OnlyOwner() {
        if (msg.sender != owner) {
            revert NotOwner({owner: owner, sender: msg.sender});
        }
        _;
    }

    modifier UserHasFunds(address addr) {
        if (balance[addr] == 0) {
            revert UserHasNoFunds({userAddress: addr});
        }
        _;
    }

    modifier UserCanAddFunds() {
        if (!usersMap[msg.sender].canAddFunds) {
            revert UserCannotAddFunds({userAddress: msg.sender});
        }
        _;
    }

    modifier AmoutValid(uint256 amount) {
        if (amount < Fee) {
            revert AmountToSmall();
        }
        _;
    }

    // transfer OwnerShip

    function transferOwnership(address newOwner) public OnlyOwner {
        owner = payable(newOwner);
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}