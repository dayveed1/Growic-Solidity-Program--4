pragma solidity >=0.4.16 <0.9.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// My Contract
contract MyContract is ERC20 {
    constructor() payable ERC20("Dave's TOKEN", "DHAVS") {
        // fixed supply using internal _mint function
        // here 9900 DAVZ initial supply 
        _mint(msg.sender, 9900);
    }

    // no decimals
    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    // to support receiving ETH by default
    receive() external payable {}

    fallback() external payable {}
}

