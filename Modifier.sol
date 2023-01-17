pragma solidity >=0.4.16 <0.9.0;
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";

/// User Doesnt Exist custom error
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
contract MyContract {
    /// Owner address
    address payable owner;
    /// Owner funds
    uint256 ownerFunds = 0;
    /// Owner fee
    uint8 Fee = 10;

    /// User struct
    struct User {
        string name;
        uint256 age; //unint256 for age come on! uint8 => 255 years old is enough
        // in blockchain storage is money ...
        bool canAddFunds;
    }

    /// maps addr to user
    mapping(address => User) usersMap;

    // get
    function getUser(address addr) private view returns (User memory) {
        if (usersMap[addr].age == 0) {
            // age easier  to check than name since its a string
            console.log("User doesn t exist");
            revert UserDoesntExist();
        }
        User memory user = usersMap[addr];
        console.log(
            "User Found: {name: %s, age: %s} for address: %s",
            user.name,
            user.age,
            addr
        );
        console.log("Can add funds: %s", user.canAddFunds);
        return user;
    }

    // set
    function setUser(address addr, User memory user) private {
        usersMap[addr] = user;
        console.log(
            "Added user: {name: %s, age: %s, addFundsLock: %s }",
            user.name,
            user.age,
            user.canAddFunds
        );
        // console.log accepts 4 parameters max
        console.log("User address is %s", addr);
    }

    // delete
    function deleteUser(address addr) private {
        delete usersMap[addr];
        console.log("Delete user at address %s", addr);
    }

    /// maps addr to balance
    mapping(address => uint256) balance;

    // get
    function getBalance(address addr) private view returns (uint) {
        uint256 amount = balance[addr];
        console.log("addr %s balance %s ", addr, amount);
        return amount;
    }

    // set
    function setBalance(address addr, uint256 amount) private {
        balance[addr] = amount;
        console.log("Balance set to %s for addr %s", amount, addr);
    }

    // delete
    function deleteBalance(address addr) private {
        delete balance[addr];
        console.log("Deleted %s", addr);
    }

    /// required functions

    function withdraw(address addr) public OnlyOwner UserHasFunds(addr) {
        ownerFunds = ownerFunds + balance[addr];
        setBalance(addr, 0);
    }

    function addFunds(uint256 amount)
        public
        UserCanAddFunds
        UserHasFunds(msg.sender)
        AmoutValid(amount)
    {
        setBalance(msg.sender, getBalance(msg.sender) + amount - Fee);
        ownerFunds = ownerFunds + Fee;
    }

    function setUserDetails(string calldata name, uint256 age) public {
        User memory user = User(name, age, false);
        setUser(msg.sender, user);
    }

    function getUserDetail() public view returns (User memory) {
        // remove view property to be able to send from scafold ui
        return getUser(msg.sender);
    }

    function deposit(uint256 amount) public AmoutValid(amount) {
        getUserDetail(); // reverts if user doesnt exist
        // you have to be a registered user in order to deposit
        setBalance(msg.sender, amount + getBalance(msg.sender) - Fee);
        //unlock addFunds
        usersMap[msg.sender].canAddFunds = true;
        ownerFunds = ownerFunds + Fee;
    }


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

    // tranfer OwnerShip

    function transferOwnership(address newOwner) public OnlyOwner {
        owner = payable(newOwner);
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}