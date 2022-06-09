// SPDX-License-Identifier: UNLICENSED

// cast storage --rpc-url $rpc 0xcdAA741D740cA521eC67F5056022a5fe820151F5 5
// 0x01070962fe1f95cb30e8ef68df9aad6675752fda0276d4fdc45786a0aa3ebc53
// forge test --contracts src/test/Privacy.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Privacy.sol";

contract PrivacyTest is DSTest {
    Privacy obj;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address payable contract_address;
    function setUp() public {
        contract_address = 0xcdAA741D740cA521eC67F5056022a5fe820151F5;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Privacy(contract_address);
    }

    function testPrivacyTop() public {
        console.log("Privacy initial locked state =",obj.locked()); 
        bytes32 key = 0x01070962fe1f95cb30e8ef68df9aad6675752fda0276d4fdc45786a0aa3ebc53;
        obj.unlock(bytes16(key));
        console.log("Privacy end locked state =",obj.locked()); 
        assert(obj.locked() == false);
    }
}
