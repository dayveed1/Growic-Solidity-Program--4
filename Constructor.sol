// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.16 <0.9.0; 

contract A {
    address immutable public owner;
    uint8 FEE;

    constructor (uint8 _fee) public {
        owner = msg.sender;
        FEE = _fee;
    }
}

contract B is A {
    address Owner;
    constructor(address _owner) A(20) {
       Owner = _owner;
    }

    function getOwner() public view returns (address owner){
        owner = Owner;
    }
}
