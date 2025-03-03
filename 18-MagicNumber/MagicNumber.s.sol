pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

/*
    bytecode: 0x600a600c600039600a6000f3602a60505260206050f3
    22 bytes total: 12 initialization + 10 execution

    initialization: 600a600c600039600a6000f3
    +-------+-------+-------+----+-------+-------+----+
    | 60 0a | 60 0c | 60 00 | 39 | 60 0a | 60 00 | f3 |
    +-------+-------+-------+----+-------+-------+----+
    60 PUSH1     39 COPYCODE     f3 RETURN

(copy 10 bytes of code starting at byte 12 and return them upon call)

    execution: 602a60505260206050f3
    +-------+-------+----+-------+-------+----+
    | 60 2a | 60 50 | 52 | 60 20 | 60 50 | f3 |
    +-------+-------+----+-------+-------+----+
    60 PUSH1     52 MSTORE     f3 RETURN

(store 2a (42) at location 50 then return 32 bytes from that location)

    deploy bytecode with
    cast send --private-key $PRIVATE_KEY --rpc-url $RPC_URL \
    --create 0x600a600c600039600a6000f3602a60505260206050f3
*/

contract SetSolver is Script
{
    address instance; // assign instance address
    address myAnswer; // address of the deployed bytecode
    bytes4 constant functionSelector = bytes4(keccak256("setSolver(address)"));

    function run() external
    {
        vm.startBroadcast();

        (bool success, ) = instance.call(abi.encodeWithSelector(functionSelector, myAnswer));
        require(success, "Call failed");

        vm.stopBroadcast();
    }
}


